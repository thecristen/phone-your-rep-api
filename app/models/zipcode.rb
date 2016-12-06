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
  def rep_info(random_rep)
    {
      name_and_party: "#{random_rep.first_name} #{random_rep.last_name}, #{random_rep.party}",
      dc_telephone: "#{random_rep.dc_tel}",
      district: "#{self.city}, #{self.state}",
      email: "#{random_rep.email}"
    }
  end
end
