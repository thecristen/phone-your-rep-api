# frozen_string_literal: true
class DistrictGeom < ApplicationRecord
  extend Geographic::ClassMethods
  include Geographic::InstanceMethods

  belongs_to :district, foreign_key: :full_code, primary_key: :full_code
end
