module Scrapeable
  module ClassMethods
    # Get Congress and state-wide reps
    def get_top_reps(address)
      @new_reps = []
      @address = Geocoder.address(address)
      get_state
      @reps = GetYourRep::Google.top_level_reps(@address)
      update_database
      @reps
    end

    # Get state legislators
    def get_state_reps(address)
      GetYourRep::OpenStates.now(address)
    end

    # Find reps already in the database and decide whether to update or create a new record.
    def update_database
      @db_reps = where(last_name: @reps.last_names, first_name: @reps.first_names).
                 includes(:state, :office_locations)
      self.update_rep_info_to_db
      @new_reps.each { |new_rep| new_rep.save } unless @new_reps.blank?
    end

    # Check each rep against the database.
    def update_rep_info_to_db
      @reps.each do |rep|
        @db_rep = @db_reps.detect { |db_rep| db_rep.last_name == rep.last_name }
        if @db_rep.blank?
          self.add_rep_to_db(rep)
        else
          @db_rep.update_db_rep(rep)
        end
      end
    end

    # Build a new Rep and add it to an array of new reps to be batch saved.
    def add_rep_to_db(rep)
      self.parse_new_rep_district(rep)

      new_rep            = new
      new_rep.state      = @state
      new_rep.district   = @state.districts.select { |d| d.code == @rep_district }.first
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
    def parse_new_rep_district(rep)

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
  end
end
