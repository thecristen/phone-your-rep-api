module Scrapeable
  module InstanceMethods
    # Build district offices for a new Rep.
    def build_district_office(rep)
      unless rep.district_office.blank?
        d_o             = office_locations.build
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
        c_o             = office_locations.build
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
      unless (rep.email - email).empty?
        @update_params[:email] = (self.email += rep.email)
      end
    end

    # Add rep social handles to update params.
    def update_social_handles(rep)
      @update_params[:twitter]    = rep.twitter    if twitter    != rep.twitter
      @update_params[:facebook]   = rep.facebook   if facebook   != rep.facebook
      @update_params[:youtube]    = rep.youtube    if youtube    != rep.youtube
      @update_params[:googleplus] = rep.googleplus if googleplus != rep.googleplus
    end

    # Decide whether to add rep capitol address to update params, or create a new one.
    def update_or_create_capitol_address(rep)
      return unless rep.capitol_office
      gather_office_locations
      if @capitol_office.nil?
        create_capitol_address(rep)
      else
        update_capitol_address(rep)
      end
    end

    # Create a new capitol address for existing Rep.
    def create_capitol_address(rep)
      office_locations.build(
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
      @capitol_office = office_locations.detect { |o| o.office_type == 'capitol' }
    end

    # Update committees of an existing Rep.
    def update_committees(rep)
      unless rep.committees.nil? || (rep.committees - committees).empty?
        @update_params[:committees] = (self.committees += rep.committees)
      end
    end
  end
end
