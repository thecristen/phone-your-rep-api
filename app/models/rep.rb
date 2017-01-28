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
    # Address' State, which is the parent of the :district.
    attr_accessor :state
    # Voting district found by a GIS database query to find the geometry that contains the :coordinates.
    attr_accessor :district
    # Raw Rep records from the database that need to be packaged for JSON response.
    attr_accessor :raw_reps
  end # Metaclass ----------------------------------------------------------------------------------------------------

  # Instance attribute that holds offices sorted by location after calling the :sort_ofices method.
  attr_accessor :sorted_offices

  # Find the reps in the db associated to that address and assemble into JSON blob
  def self.find_em(address: nil, lat: nil, long: nil)
    init(address, lat, long)
    return [] if coordinates.blank?
    find_district_and_state
    self.raw_reps = Rep.yours(state: state, district: district).includes(:office_locations)
    self.raw_reps = raw_reps.distinct
    raw_reps.each { |rep| rep.sort_offices(coordinates) }
  end

  def self.init(address, lat, long)
    self.raw_reps    = nil
    self.coordinates = [lat.to_f, long.to_f] - [0.0]
    self.state       = nil
    self.address     = address
    return unless coordinates.blank? && state.blank?
    find_coordinates_by_address if address
  end

  # Geocode address into [lat, lon] coordinates.
  # Collect the lat and lon from the coordinates and create a new RGeo Point object.
  def self.find_coordinates_by_address
    self.coordinates = Geocoder.coordinates(address)
  end

  # Query all of the districts within that state.
  # Select the district from the collection of state districts that contains the :point.
  def self.find_district_and_state
    lat           = coordinates.first
    lon           = coordinates.last
    self.district = DistrictGeom.containing_latlon(lat, lon).includes(:district).take.district
    self.state    = district.state
  end

  # Sort the offices by proximity to the request coordinates, making sure to not miss offices that aren't geocoded.
  def sort_offices(coordinates)
    closest_offices       = office_locations.near(coordinates, 4000)
    closest_offices      += office_locations
    self.sorted_offices   = closest_offices.uniq || []
    sorted_offices.blank? ? [] : sorted_offices.each { |office| office.calculate_distance(coordinates) }
  end

  def district_code
    district.code unless district_id.blank?
  end

  def sorted_offices_array
    return sorted_offices if sorted_offices
    office_locations
  end
end
