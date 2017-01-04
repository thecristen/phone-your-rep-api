class Rep < ApplicationRecord
  extend Scrapeable::ClassMethods
  include Scrapeable::InstanceMethods

  belongs_to :district
  belongs_to :state
  has_many   :office_locations, dependent: :destroy
  serialize  :committees, Array
  serialize  :email, Array

  # Find the reps in the db associated to that address and assemble into JSON blob
  def self.find_em(address)
    @address = address
    find_coordinates
    find_state
    find_district
    find_raw_reps
    cook_the_reps
  end

  # Geocode address into [lat, lon] coordinates.
  def self.find_coordinates
    @coordinates = Geocoder.coordinates(@address)
    lat = @coordinates.first
    lon = @coordinates.last
    @point = RGeo::Cartesian.factory.point(lon, lat)
  end

  # Parse out the two letter state abbreviation from address and find the State by that attribute.
  def self.find_state
    state_abbr = @address.split.grep(/[A-Z]{2}/)
    @state = State.where(abbr: state_abbr).includes(:districts).first
  end

  # Query all of the districts within that state by :state_code foreign key.
  # Collect the lat and lon from the coordinates and create a new RGeo Point object.
  # Select the district from the collection of state districts that contains the point.
  def self.find_district
    @district = @state.districts.detect { |district| @point.within?(district.geom) }
  end

  # Query for Reps that belong to either the state or the district.
  # Add the reps to a @raw_reps array.
  def self.find_raw_reps
    @raw_reps = []
    @raw_reps += Rep.where(district: @district).
                     or(Rep.where(state: @state, district: nil)).
                     includes(:office_locations, :district).to_a
    @raw_reps.uniq!
  end

  # Instantiate a new Delegation. Iterate over @raw_reps and assemble their attributes into a new
  # Representative. Structure the Representative to be used as a JSON blob.
  def self.cook_the_reps
    @raw_reps.map do |rep|
      rep.sort_offices(@coordinates)
      {
        name:             rep.name,
        state:            @state.abbr,
        district:         rep.district&.code,
        office:           rep.office,
        party:            rep.party,
        phone:            rep.sorted_phones,
        office_locations: rep.sorted_offices,
        email:            rep.email,
        url:              rep.url,
        photo:            rep.photo,
        twitter:          rep.twitter,
        facebook:         rep.facebook,
        youtube:          rep.youtube,
        googleplus:       rep.googleplus
      }
    end
  end

  # Pick a random rep and assemble into JSON blob.
  def self.random_rep
    random_rep = Rep.order("RANDOM()").limit(1).first
    return [] << { error: 'Something went wrong, try again.' } if random_rep.nil?
    [] << {
      name:             random_rep.name,
      state:            random_rep.state.abbr,
      district:         random_rep.district&.code,
      office:           random_rep.office,
      party:            random_rep.party,
      phone:            random_rep.phones,
      office_locations: random_rep.offices,
      email:            random_rep.email,
      url:              random_rep.url,
      photo:            random_rep.photo,
      twitter:          random_rep.twitter,
      facebook:         random_rep.facebook,
      youtube:          random_rep.youtube,
      googleplus:       random_rep.googleplus
    }
  end

  # Sort the offices by proximity to the request coordinates, making sure to not miss offices that aren't geocoded.
  def sort_offices(coordinates)
    @sorted_offices  = office_locations.near(coordinates, 4000)
    @sorted_offices += office_locations
    @sorted_offices.uniq!
  end

  # Map the phones in order of the sorted offices
  def sorted_phones
    @sorted_offices.map { |office| office.phone } - [nil]
  end

  # Parse the rep's office locations into hashes and map them in the sorted order.
  def sorted_offices
    @sorted_offices.map do |office|
      {
        type:   office.office_type,
        line_1: office.line1,
        line_2: office.line2,
        line_3: office.line3,
        line_4: office.line4,
        line_5: office.line5
      }
    end
  end

  # Map the phone number of every office location into one Array.
  def phones
    office_locations.map { |office| office.phone } - [nil]
  end

  # Map the office locations into one Array.
  def offices
    office_locations.map do |office|
      {
        type:   office.office_type,
        line_1: office.line1,
        line_2: office.line2,
        line_3: office.line3,
        line_4: office.line4,
        line_5: office.line5
      }
    end
  end

  # Convert shorthand party to long-form.
  def party
    case self[:party]
    when 'D'
      'Democratic'
    when 'R'
      'Republican'
    when 'I'
      'Independent'
    else
      self[:party]
    end
  end
end
