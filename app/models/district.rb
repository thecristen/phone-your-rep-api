# frozen_string_literal: true
class District < ApplicationRecord
  belongs_to :state, foreign_key: :state_code, primary_key: :state_code
  has_many   :reps

  FACTORY = RGeo::Geographic.simple_mercator_factory
  EWKB = RGeo::WKRep::WKBGenerator.new(:type_format => :ewkb,
                                       :emit_ewkb_srid => true, :hex_format => true)

  def contains?(point)
    point.within?(geom)
  end

  def self.containing_latlon(lat, lon)
    ewkb = EWKB.generate(FACTORY.point(lon, lat).projection)
    where("ST_Intersects(geom, ST_GeomFromEWKB(E'\\\\x#{ewkb}'))").includes(:state).take
  end
end
