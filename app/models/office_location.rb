# frozen_string_literal: true
class OfficeLocation < ApplicationRecord
  belongs_to       :rep
  validates        :office_type, :line1, presence: true
  geocoded_by      :full_address
  after_validation :geocode, :set_lonlat

  def set_lonlat
    self[:lonlat] = RGeo::Cartesian.factory.point(longitude, latitude)
  end

  def full_address
    [line1, line2, line3, line4, line5].join(' ')
  end

  def to_hash
    { type:   office_type,
      line_1: line1,
      line_2: line2,
      line_3: line3,
      line_4: line4,
      line_5: line5 }
  end
end
