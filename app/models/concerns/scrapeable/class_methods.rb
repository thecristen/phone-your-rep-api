# frozen_string_literal: true
module Scrapeable
  module ClassMethods
    # Get Congress and state-wide reps
    def get_top_reps(address)
      @new_reps = []
      @address = Geocoder.address(address)
      find_state
      @delegation = GetYourRep::Google.all_reps(@address, congress_only: true)
      update_database
      @delegation
    end

    # Get state legislators
    def get_state_reps(address)
      GetYourRep::OpenStates.all_reps(address)
    end

    # Find reps already in the database and decide whether to update or create a new record.
    def update_database
      @db_reps = where(last_name: @delegation.last_names, first_name: @delegation.first_names).
                 includes(:state, :office_locations)
      update_rep_info_to_db
      @new_reps.each(&:save) unless @new_reps.blank?
    end

    # Check each rep against the database.
    def update_rep_info_to_db
      @delegation.reps.each do |rep|
        @db_rep = @db_reps.detect { |db_rep| db_rep.last_name == rep.last_name && db_rep.first_name == rep.first_name }
        if @db_rep.blank?
          add_rep_to_db(rep)
        else
          @db_rep.update_db_rep(rep)
        end
      end
    end

    # Build a new Rep (and it's office locations) and add it to an array of new reps to be batch saved.
    def add_rep_to_db(rep)
      @rep_district = parse_new_rep_district(rep)
      new_rep = build_rep(rep)
      new_rep.build_district_offices(rep)
      new_rep.build_capitol_offices(rep)
      @new_reps << new_rep
    end

    # Build the new rep.
    def build_rep(rep)
      new_rep            = new
      new_rep.state      = @state
      new_rep.district   = @state.districts.detect { |district| district.code == @rep_district }
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
      new_rep
    end

    # Parse out the congressional district info of a new Rep.
    def parse_new_rep_district(rep)
      rep_office          = rep.office
      rep_office_downcase = rep_office.downcase
      office_suffix       = rep_office.split(' ').last

      if rep_office_downcase =~ /(united states house)/

        if office_suffix =~ /[A-Z]{2}-[0-9]{2}/
          office_suffix.split('-').last
        else
          '00'
        end

      elsif rep_office_downcase =~ /(united states senate)|(governor)/
        nil
      elsif rep_office_downcase =~ /upper|lower|chamber/
        office_suffix
      end
    end
  end
end
