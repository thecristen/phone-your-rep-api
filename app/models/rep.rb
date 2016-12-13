class Rep < ApplicationRecord

  def self.get_all_reps(address)
    @reps = GetYourRep.all(address)
    @reps_last_names = @reps.last_names
    @reps_first_names = @reps.first_names
    @db_reps = self.where(last_name: @reps_last_names, first_name: @reps_first_names)
    update_district_info
    @reps
  end

  def self.update_district_info
    i = 0
    @reps_last_names.each do |rep|
      db_rep = @db_reps.select { |db_rep| db_rep.last_name == rep }
      if db_rep.blank?
        i += 1
        next
      end
      @reps[i][:phone]     = db_rep[0].district_tel
      @reps[i][:email]     = db_rep[0].email
      @reps[i][:address_1] = db_rep[0].district_office_address_line_1
      @reps[i][:address_2] = db_rep[0].district_address_line_2
      @reps[i][:address_3] = db_rep[0].district_address_line_3
      i += 1
    end
  end
end
