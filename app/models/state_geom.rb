# frozen_string_literal: true
class StateGeom < ApplicationRecord
  extend Geographic::ClassMethods
  include Geographic::InstanceMethods

  FACTORY = RGeo::Geographic.simple_mercator_factory
  EWKB = RGeo::WKRep::WKBGenerator.new(type_format:    :ewkb,
                                       emit_ewkb_srid: true,
                                       hex_format:     true)

  belongs_to :state, foreign_key: :state_code, primary_key: :state_code
end
