# frozen_string_literal: true
class Rep < ApplicationRecord
  extend  Scrapeable::ClassMethods
  include Scrapeable::InstanceMethods

  belongs_to :district
  belongs_to :state
  has_many   :office_locations, dependent: :destroy
  scope      :yours, ->(state:, district:) { where(district: district).or(Rep.where(state: state, district: nil)) }
  serialize  :committees, Array
  serialize  :email, Array

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
  end # Metaclass ----------------------------------------------------------------------------------------------------

  # Instance attribute that holds offices sorted by location after calling the :sort_ofices method.
  attr_accessor :sorted_offices

  # Find the reps in the db associated to that address and assemble into JSON blob
  def self.find_em(address)
    self.address = address
    find_location_data
    find_reps
  end

  def self.find_location_data
    find_coordinates
    find_state
    find_district
  end

  # Geocode address into [lat, lon] coordinates.
  # Collect the lat and lon from the coordinates and create a new RGeo Point object.
  def self.find_coordinates
    self.coordinates = Geocoder.coordinates(address)
    lat              = coordinates.first
    lon              = coordinates.last
    self.point       = RGeo::Cartesian.factory.point(lon, lat)
  end

  # Parse out the two letter state abbreviation from address and find the State by that attribute.
  def self.find_state
    state_abbr = address.split.grep(/[A-Z]{2}/)
    self.state = State.by_abbr_with_districts(abbr: state_abbr)
  end

  # Query all of the districts within that state.
  # Select the district from the collection of state districts that contains the :point.
  def self.find_district
    self.district = state.districts.detect { |district| district.contains?(point) }
  end

  # Query for Reps that belong to either the state or the district.
  # Add the reps to a :raw_reps array and eliminate any dupes.
  def self.find_reps
    self.raw_reps = Rep.yours(state: state, district: district).includes(:office_locations, :district).to_a
    raw_reps.uniq!
    prep_the_reps
  end

  # Iterate over @raw_reps and assemble their attributes into a hash for JSON delivery.
  def self.prep_the_reps
    raw_reps.map do |rep|
      rep.sort_offices(coordinates)
      rep.to_hash(state)
    end
  end

  # Pick a random rep and assemble into JSON blob.
  def self.random_rep
    random_rep = Rep.order('RANDOM()').limit(1).first
    return [] << { error: 'Something went wrong, try again.' } unless random_rep
    [] << random_rep.to_hash
  end

  # Assemble rep into hash, handling office sorting and nil :district
  def to_hash(state = self.state)
    { name:             name,
      state:            state.abbr,
      district:         district_code,
      office:           office,
      party:            party,
      phone:            sorted_phones,
      office_locations: sorted_offices_hash,
      email:            email,
      url:              url,
      photo:            photo,
      twitter:          twitter,
      facebook:         facebook,
      youtube:          youtube,
      googleplus:       googleplus }
  end

  # Sort the offices by proximity to the request coordinates, making sure to not miss offices that aren't geocoded.
  def sort_offices(coordinates)
    closest_offices       = office_locations.near(coordinates, 4000)
    closest_offices      += office_locations
    self.sorted_offices   = closest_offices.uniq! || []
  end

  def district_code
    district.code unless district.blank?
  end

  def sorted_offices_hash
    sorted_offices.map(&:to_hash)
  end

  # Map the phone number of every office location into one Array, sorting by location if possible.
  def sorted_phones
    sorted_offices.map(&:phone) - [nil]
  end

  # Convert shorthand party to long-form.
  def party
    party = self[:party]
    case party
    when 'D'
      'Democratic'
    when 'R'
      'Republican'
    when 'I'
      'Independent'
    else
      party
    end
  end
end
