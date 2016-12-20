class OfficeLocation < ApplicationRecord
  belongs_to :rep
  validates :line1, :line2, :phone, presence: true
  geocoded_by :full_address
  after_validation :geocode, if: :address_changed?

  def full_address
    [line1, line2, line3, line4, line5].join(' ')
  end
end
