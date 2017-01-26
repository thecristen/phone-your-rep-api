# frozen_string_literal: true
require_relative '../config/environment.rb'

def import_shapefile(dir:, shp_file:, model:, model_attr:, record_attr:)
  RGeo::Shapefile::Reader.
    open(Rails.root.join('lib', 'shapefiles', dir, shp_file).to_s, factory: model::FACTORY) do |file|
    puts "File contains #{file.num_records} records."
    file.each do |record|
      puts "Record number #{record.index}:"
      record.geometry.projection.each do |poly|
        model.create(model_attr => record.attributes[record_attr],
                     :geom      => poly)
      end
      puts record.attributes
    end
  end
end

import_shapefile(dir:           'us_states_122116',
                 shp_file:      'cb_2015_us_state_500k.shp',
                 model:         StateGeom,
                 model_attr:    :state_code,
                 record_attr:   'STATEFP')

import_shapefile(dir:           'us_congress_districts_122116',
                 shp_file:      'cb_2015_us_cd114_500k.shp',
                 model:         DistrictGeom,
                 model_attr:    :full_code,
                 record_attr:   'GEOID')
