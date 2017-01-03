class Rep < ApplicationRecord
  belongs_to :district
  belongs_to :state
  has_many   :office_locations, dependent: :destroy
  serialize  :committees, Array
  serialize  :email, Array

  # Find the reps in the db associated to that address and assemble into JSON blob
  def self.get_em(address)
    @address = address
    self.get_coordinates
    self.get_state
    self.get_district
    self.get_raw_state_and_district_reps
    self.cook_the_reps
  end

  # Geocode address into [lat, lon] coordinates.
  def self.get_coordinates
    @coordinates = Geocoder.coordinates(@address)
    lat = @coordinates.first
    lon = @coordinates.last
    @point = RGeo::Cartesian.factory.point(lon, lat)
  end

  # Parse out the two letter state abbreviation from address and find the State by that attribute.
  def self.get_state
    state_abbr = @address.split.grep(/[A-Z]{2}/)
    @state = State.where(abbr: state_abbr).includes(:districts).first
  end

  # Query all of the districts within that state by :state_code foreign key.
  # Collect the lat and lon from the coordinates and create a new RGeo Point object.
  # Select the district from the collection of state districts that contains the point.
  def self.get_district
    districts = @state.districts
    @district = districts.select { |district| @point.within?(district.geom) }.first
  end

  # Query for Reps that belong to either the state or the district.
  # Add the reps to a @raw_reps array.
  def self.get_raw_state_and_district_reps
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
      district:         (random_rep.district.code if random_rep.district),
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

  # Sort the offices by proximity to the request coordinates
  def sort_offices(coordinates)
    @sorted_offices  = self.office_locations.near(coordinates, 4000)
    @sorted_offices += self.office_locations
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
    self.office_locations.map { |office| office.phone } - [nil]
  end

  # Map the office locations into one Array.
  def offices
    self.office_locations.map do |office|
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

  # Convert shorthand party to longform.
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

  #------------------------------------------------------------------------------------------------
  #
  # The methods below are used to pull in rep data from the Google and Open States APIs and
  # update the database
  #
  #------------------------------------------------------------------------------------------------

  # Get Congress and state-wide reps
  def self.get_top_reps(address)
    @new_reps = []
    @address = Geocoder.address(address)
    self.get_state
    @reps = GetYourRep::Google.top_level_reps(@address)
    self.update_database
    @reps
  end

  # Get state legislators
  def self.get_state_reps(address)
    GetYourRep::OpenStates.now(address)
  end

  # Find reps already in the database and decide whether to update or create a new record.
  def self.update_database
    @db_reps = self.where(last_name: @reps.last_names, first_name: @reps.first_names)
    self.update_rep_info_to_db
    @new_reps.each { |new_rep| new_rep.save } unless @new_reps.blank?
  end

  # Check each rep against the database.
  def self.update_rep_info_to_db
    @reps.each do |rep|
      @db_rep = @db_reps.select { |db_rep| db_rep.last_name == rep.last_name }.first
      if @db_rep.blank?
        self.add_rep_to_db(rep)
      else
        @db_rep.update_db_rep(rep)
      end
    end
  end

  # Build a new Rep and add it to an array of new reps to be batch saved.
  def self.add_rep_to_db(rep)
    self.parse_new_rep_district(rep)

    new_rep            = Rep.new
    new_rep.state      = @state
    new_rep.district   = District.where(code: @rep_district, state_code: @state.state_code).first
    new_rep.office     = rep.office
    new_rep.name       = rep.name
    new_rep.last_name  = rep.last_name
    new_rep.first_name = rep.first_name
    new_rep.party      = rep.party
    new_rep.email      = rep.email
    new_rep.url        = rep.url
    new_rep.twitter    = rep.twitter
    new_rep.facebook   = rep.facebook
    new_rep.youtube    = rep.youtube
    new_rep.googleplus = rep.googleplus
    new_rep.photo      = rep.photo
    new_rep.committees = rep.committees

    new_rep.build_district_office(rep)
    new_rep.build_capitol_office(rep)
    @new_reps << new_rep
  end

  # Parse out the congressional district info of a new Rep.
  def self.parse_new_rep_district(rep)

    if rep.office.downcase.match(/(united states house)/)
      office_suffix = rep.office.split(' ').last

      if office_suffix.match(/[A-Z]{2}-[0-9]{2}/)
        @rep_district = office_suffix.split('-').last
      else
        @rep_district = '00'
      end

    elsif rep.office.downcase.match(/(united states senate)|(governor)/)
      @rep_district = nil

    elsif rep.office.downcase.match(/upper|lower|chamber/)
      office_array  = rep.office.split(' ')
      @rep_district = office_array.last

    end
  end

  # Build district offices for a new Rep.
  def build_district_office(rep)
    unless rep.district_office.blank?
      d_o             = self.office_locations.build
      d_o.office_type = 'district'
      d_o.line1       = rep.district_office[:line_1]
      d_o.line2       = rep.district_office[:line_2]
      d_o.line3       = rep.district_office[:line_3]
      d_o.phone       = rep.phone.first
    end
  end

  # Build capitol offices for a new Rep.
  def build_capitol_office(rep)
    unless rep.capitol_office.blank?
      c_o             = self.office_locations.build
      c_o.office_type = 'capitol'
      c_o.line1       = rep.capitol_office[:line_1]
      c_o.line2       = rep.capitol_office[:line_2]
      c_o.line3       = rep.capitol_office[:line_3]
      c_o.phone       = rep.phone.last
    end
  end

  # Build update params for an existing Rep.
  def update_db_rep(rep)
    @update_params = {}
    @update_params[:state]  = @state     if self.state.nil?
    @update_params[:office] = rep.office if self.office != rep.office
    @update_params[:party]  = rep.party  if self.party  != rep.party
    self.update_email(rep)
    self.update_social_handles(rep)
    self.update_or_create_capitol_address(rep)
    self.update_committees(rep)
    self.update(@update_params) unless @update_params.blank?
  end

  # Add rep email to update params.
  def update_email(rep)
    unless (rep.email - self.email).empty?
      @update_params[:email] = (self.email += rep.email)
    end
  end

  # Add rep social handles to update params.
  def update_social_handles(rep)
    @update_params[:twitter]    = rep.twitter    if self.twitter    != rep.twitter
    @update_params[:facebook]   = rep.facebook   if self.facebook   != rep.facebook
    @update_params[:youtube]    = rep.youtube    if self.youtube    != rep.youtube
    @update_params[:googleplus] = rep.googleplus if self.googleplus != rep.googleplus
  end

  # Decide whether to add rep capitol address to update params, or create a new one.
  def update_or_create_capitol_address(rep)
    return unless rep.capitol_office
    self.gather_office_locations
    if @capitol_office.nil?
      self.create_capitol_address(rep)
    else
      self.update_capitol_address(rep)
    end
  end

  # Create a new capitol address for existing Rep.
  def create_capitol_address(rep)
    self.office_locations.build(
      office_type: rep.capitol_office[:type],
      line1:       rep.capitol_office[:line_1],
      line2:       rep.capitol_office[:line_2],
      line3:       rep.capitol_office[:line_3],
      line4:       rep.capitol_office[:line_4],
      line5:       rep.capitol_office[:line_5],
    )
  end

  # Update an existing capitol address for existing Rep.
  def update_capitol_address(rep)
    @cap_office_update_params = {}

    if @capitol_office.line1 != rep.capitol_office[:line_1]
      @cap_office_update_params[:line1] = rep.capitol_office[:line_1]
    end

    if @capitol_office.line2 != rep.capitol_office[:line_2]
      @cap_office_update_params[:line2] = rep.capitol_office[:line_2]
    end

    if @capitol_office.line3 != rep.capitol_office[:line_3]
      @cap_office_update_params[:line3] = rep.capitol_office[:line_3]
    end

    @capitol_office.update(@cap_office_update_params) unless @cap_office_update_params.blank?
  end

  # Gather the capitol office location of an existing Rep.
  def gather_office_locations
    @capitol_office = self.office_locations.where(office_type: 'capitol').first
  end

  # Update committees of an existing Rep.
  def update_committees(rep)
    unless rep.committees.nil? || (rep.committees - self.committees).empty?
      @update_params[:committees] = (self.committees += rep.committees)
    end
  end
end
