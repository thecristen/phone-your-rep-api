class Rep < ApplicationRecord

  def self.get_all_reps(address)
    @reps = GetYourRep.all(address)
    @db_reps = self.where(last_name: @reps.last_names, first_name: @reps.first_names)
    update_district_info
    @reps
  end

  def self.update_district_info
    @reps.each do |rep|
      db_rep = @db_reps.select { |db_rep| db_rep.last_name == rep.last_name }
      next if db_rep.blank?
      rep.phone     = db_rep[0].district_tel
      rep.email     = db_rep[0].email
      rep.address_1 = db_rep[0].district_office_address_line_1
      rep.address_2 = db_rep[0].district_address_line_2
      rep.address_3 = db_rep[0].district_address_line_3
    end
  end
end
