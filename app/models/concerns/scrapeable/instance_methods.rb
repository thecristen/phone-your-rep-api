# frozen_string_literal: true
module Scrapeable
  module InstanceMethods
    # Build district offices for a new Rep.
    def build_district_offices(rep)
      return if rep.district_offices.blank?

      rep.district_offices.each do |office|
        d_o             = office_locations.build
        d_o.office_type = 'district'
        d_o.line1       = office.line_1
        d_o.line2       = office.line_2
        d_o.line3       = office.line_3
        d_o.phone       = rep.phones.first
      end
    end

    # Build capitol offices for a new Rep.
    def build_capitol_offices(rep)
      return if rep.capitol_offices.blank?

      rep.capitol_offices.each do |office|
        c_o             = office_locations.build
        c_o.office_type = 'capitol'
        c_o.line1       = office.line_1
        c_o.line2       = office.line_2
        c_o.line3       = office.line_3
        c_o.phone       = rep.phones.last
      end
    end

    # Build update params for an existing Rep.
    def update_db_rep(rep)
      @update_params = {}
      @update_params[:state]  = @state     if state.nil?
      @update_params[:office] = rep.office if office != rep.office
      @update_params[:party]  = rep.party  if party  != rep.party
      update_email(rep)
      update_social_handles(rep)
      update_or_create_capitol_address(rep)
      update_committees(rep)
      update(@update_params) unless @update_params.blank?
    end

    # Add rep email to update params.
    def update_email(rep)
      @update_params[:email] = (self.email += rep.email) unless (rep.email - email).empty?
    end

    # Add rep social handles to update params.
    def update_social_handles(rep)
      @update_params[:twitter]    = rep.twitter    if twitter.nil?
      @update_params[:facebook]   = rep.facebook   if facebook.nil?
      @update_params[:youtube]    = rep.youtube    if youtube.nil?
      @update_params[:googleplus] = rep.googleplus if googleplus.nil?
    end

    # Decide whether to add rep capitol address to update params, or create a new one.
    def update_or_create_capitol_address(rep)
      return if rep.capitol_offices.blank?
      gather_office_locations
      if @capitol_office.blank?
        create_capitol_address(rep)
      else
        update_capitol_address(rep)
      end
    end

    # Create a new capitol address for existing Rep.
    def create_capitol_address(rep)
      rep.capitol_offices.each do |office|
        office_locations.build(office_type: office.type,
                               line1:       office.line_1,
                               line2:       office.line_2,
                               line3:       office.line_3,
                               line4:       office.line_4,
                               line5:       office.line_5)
      end
    end

    # Update an existing capitol address for existing Rep.
    def update_capitol_address(rep)
      @cap_office_update_params = {}

      if @capitol_office.line1 != rep.capitol_offices[0].line_1
        @cap_office_update_params[:line1] = rep.capitol_offices[0].line_1
      end

      if @capitol_office.line2 != rep.capitol_offices[0].line_2
        @cap_office_update_params[:line2] = rep.capitol_offices[0].line_2
      end

      if @capitol_office.line3 != rep.capitol_offices[0].line_3
        @cap_office_update_params[:line3] = rep.capitol_offices[0].line_3
      end

      @capitol_office.update(@cap_office_update_params) unless @cap_office_update_params.blank?
    end

    # Gather the capitol office location of an existing Rep.
    def gather_office_locations
      @capitol_office = office_locations.detect { |o| o.office_type == 'capitol' }
    end

    # Update committees of an existing Rep.
    def update_committees(rep)
      return if rep.committees.blank? || (rep.committees - committees).empty?
      @update_params[:committees] = (self.committees += rep.committees)
    end
  end
end
