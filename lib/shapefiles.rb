require_relative '../config/environment.rb'

def import_geoms(dir:, shp_file:, model:, model_attr:, record_attr:)
  RGeo::Shapefile::Reader.open(Rails.root.join(
    'lib', 'shapefiles', dir, shp_file
  ).to_s) do |file|
    puts "File contains #{file.num_records} records."
    file.each do |record|
      puts "Record number #{record.index}:"
      instance = model.find_by(model_attr => record.attributes[record_attr])
      instance.update(geom: record.geometry)
      puts record.attributes
    end
  end
end

import_geoms(dir:         'us_states_122116',
             shp_file:    'cb_2015_us_state_500k.shp',
             model:       State,
             model_attr:  :state_code,
             record_attr: 'STATEFP')

import_geoms(dir:         'us_congress_districts_122116',
             shp_file:    'cb_2015_us_cd114_500k.shp',
             model:       District,
             model_attr:  :full_code,
             record_attr: 'GEOID')
