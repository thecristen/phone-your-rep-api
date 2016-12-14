class Zipcode < ApplicationRecord
  attr_accessor :senators, :random_rep

  # find Senators in the same state
  def senators
    @senators = Rep.where(state: self.state)
  end

  # select a random rep from available Senators
  def random_rep
    @random_rep = senators.sample
  end

  # extract Rep info and Zipcode location into
  def rep_info(rep)
    {
      name_and_party: "#{rep.first_name} #{rep.last_name}, #{rep.party}",
      district_telephone: "#{rep.district_tel}",
      district: "#{self.city}, #{self.state}",
      email: "#{rep.email}",
      website: "#{rep.website}",
      address_1: "#{rep.district_office_address_line_1}",
      address_2: "#{rep.district_address_line_2}",
      address_3: "#{rep.district_address_line_3}"
    }
  end

  def self.random_zip
    Zipcode.order("RANDOM()").limit(1)[0]
  end
end
