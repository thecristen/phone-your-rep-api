# frozen_string_literal: true
module Scrapeable
  module ClassMethods
    # Get Congress and state-wide reps
    def get_top_reps(address)
      @new_reps = []
      @address = Geocoder.address(address)
      find_state
      @delegation = GetYourRep::Google.top_level_reps(@address)
      update_database
      @delegation
    end

    # Get state legislators
    def get_state_reps(address)
      GetYourRep::OpenStates.now(address)
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
      parse_new_rep_district(rep)
      new_rep = build_rep(rep)
      new_rep.build_district_offices(rep)
      new_rep.build_capitol_offices(rep)
      @new_reps << new_rep
    end

    # Build the new rep.
    def build_rep(rep)
      r            = new
      r.state      = @state
      r.district   = @state.districts.detect { |d| d.code == @rep_district }
      r.office     = rep.office
      r.name       = rep.name
      r.last_name  = rep.last_name
      r.first_name = rep.first_name
      r.party      = rep.party
      r.email      = rep.email
      r.url        = rep.url
      r.twitter    = rep.twitter
      r.facebook   = rep.facebook
      r.youtube    = rep.youtube
      r.googleplus = rep.googleplus
      r.photo      = rep.photo
      r
    end

    # Parse out the congressional district info of a new Rep.
    def parse_new_rep_district(rep)
      @rep_district = if !(rep.office.downcase =~ /(united states house)/).nil?
                        office_suffix = rep.office.split(' ').last

                        if !(office_suffix =~ /[A-Z]{2}-[0-9]{2}/).nil?
                          office_suffix.split('-').last
                        else
                          '00'
                        end

                      elsif (rep.office.downcase =~ /(united states senate)|(governor)/).nil?
                        nil
                      elsif (rep.office.downcase =~ /upper|lower|chamber/).nil?
                        rep.office.split(' ').last
                      end
    end
  end
end
