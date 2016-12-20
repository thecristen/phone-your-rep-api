class OfficeLocation < ApplicationRecord
  belongs_to :rep
  validates :office_type, :line1, presence: true
  geocoded_by :full_address
  after_validation :geocode

  def full_address
    [line1, line2, line3, line4, line5].join(' ')
  end
end
