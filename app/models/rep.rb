# frozen_string_literal: true
class Rep < ApplicationRecord
  belongs_to :district
  belongs_to :state
  has_many   :office_locations, dependent: :destroy, foreign_key: :bioguide_id, primary_key: :bioguide_id
  scope      :yours, ->(state:, district:) { where(district: district).or(Rep.where(state: state, district: nil)) }
  serialize  :committees, Array

  # Open up Rep Metaclass to set Class attributes --------------------------------------------------------------------
  class << self
    # Address value from params.
    attr_accessor :address
    # Lat/lon coordinates geocoded from :address.
    attr_accessor :coordinates
    # Cartesian point object representing coordinates that can be used to find the :district by spatial geometry.
    attr_accessor :point
    # Address' State, found by parsing :address for the two-letter abbreviation.
    attr_accessor :state
    # Voting district found by a GIS database query to find the geometry that envelopes the :point.
    attr_accessor :district
    # Raw Rep records from the database that need to be packaged for JSON response.
    attr_accessor :raw_reps
    # State abbreviation parsed from address params.
    attr_accessor :state_abbr
  end # Metaclass ----------------------------------------------------------------------------------------------------

  # Instance attribute that holds offices sorted by location after calling the :sort_ofices method.
  attr_accessor :sorted_offices

  # Find the reps in the db associated to that address and assemble into JSON blob
  def self.find_em(address: nil, lat: nil, long: nil, state: nil)
    init(address, lat, long, state)
    return [] if coordinates.blank?
    find_district_and_state
    find_reps
  end

  def self.init(address, lat, long, state)
    self.raw_reps    = nil
    self.coordinates = [lat.to_f, long.to_f] - [0.0]
    self.state       = nil
    self.address     = address
    return unless coordinates.blank? && self.state.blank?
    find_by_address if address
  end

  def self.find_by_address
    find_coordinates
  end

  # Geocode address into [lat, lon] coordinates.
  # Collect the lat and lon from the coordinates and create a new RGeo Point object.
  def self.find_coordinates
    self.coordinates = Geocoder.coordinates(address)
  end

  # Query all of the districts within that state.
  # Select the district from the collection of state districts that contains the :point.
  def self.find_district_and_state
    lat           = coordinates.first
    lon           = coordinates.last
    self.district = DistrictGeom.containing_latlon(lat, lon).take.district
    self.state    = district.state
  end

  # Query for Reps that belong to either the state or the district.
  # Add the reps to a :raw_reps array and eliminate any dupes.
  def self.find_reps
    self.raw_reps = Rep.yours(state: state, district: district).includes(:office_locations).to_a
    process_reps
  end

  def self.process_reps
    raw_reps.uniq!
    build_rep_hashes
  end

  # Iterate over @raw_reps and assemble their attributes into a hash for JSON delivery.
  def self.build_rep_hashes
    raw_reps.map do |rep|
      rep.sort_offices(coordinates)
      rep.to_hash(state, district)
    end
  end

  # Assemble rep into hash, handling office sorting and nil :district
  def to_hash(state = self.state, district = self.district)
    { bioguide_id:      bioguide_id,
      official_full:    official_full,
      state:            state.abbr,
      district:         district_code(district),
      role:             role,
      party:            party,
      senate_class:     senate_class,
      last:             last,
      first:            first,
      middle:           middle,
      nickname:         nickname,
      suffix:           suffix,
      contact_form:     contact_form,
      url:              url,
      photo:            photo,
      twitter:          twitter,
      facebook:         facebook,
      youtube:          youtube,
      instagram:        instagram,
      googleplus:       googleplus,
      twitter_id:       twitter_id,
      facebook_id:      facebook_id,
      youtube_id:       youtube_id,
      instagram_id:     instagram_id,
      office_locations: sorted_offices_array }
  end

  # Sort the offices by proximity to the request coordinates, making sure to not miss offices that aren't geocoded.
  def sort_offices(coordinates)
    closest_offices       = office_locations.near(coordinates, 4000)
    closest_offices      += office_locations
    self.sorted_offices   = closest_offices.uniq || []
    sorted_offices.blank? ? [] : sorted_offices.each { |office| office.calculate_distance(coordinates) }
  end

  def district_code(district)
    district.code unless self.district_id.blank?
  end

  def sorted_offices_array
    sorted_offices.map(&:to_hash)
  end

  # Convert shorthand party to long-form.
  def party
    party = self[:party]
    case party
    when 'D'
      'Democrat'
    when 'R'
      'Republican'
    when 'I'
      'Independent'
    else
      party
    end
  end
end
