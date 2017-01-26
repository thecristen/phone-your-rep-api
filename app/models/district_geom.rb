# frozen_string_literal: true
class DistrictGeom < ApplicationRecord
  extend Geographic::ClassMethods
  include Geographic::InstanceMethods

  FACTORY = RGeo::Geographic.simple_mercator_factory
  EWKB = RGeo::WKRep::WKBGenerator.new(type_format:    :ewkb,
                                       emit_ewkb_srid: true,
                                       hex_format:     true)

  belongs_to :district, foreign_key: :full_code, primary_key: :full_code
end
