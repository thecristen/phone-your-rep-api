# frozen_string_literal: true
class ZctaDistrict < ApplicationRecord
  belongs_to :zcta
  belongs_to :district
end
