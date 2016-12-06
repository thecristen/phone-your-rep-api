class Zipcode < ApplicationRecord
  attr_accessor :senators

  def senators
    @senators = Rep.where(state: self.state)
  end
end
