require_relative '../config/environment.rb'

def import_state_geoms
  RGeo::Shapefile::Reader.open(Rails.root.join(
      'lib', 'shapefiles', 'us_states_122116', 'cb_2015_us_state_500k.shp'
  ).to_s) do |file|
    puts "File contains #{file.num_records} records."
    file.each do |record|
      puts "Record number #{record.index}:"
      state = State.find_by(state_code: record.attributes['STATEFP'])
      state.update(geom: record.geometry)
      puts record.attributes
    end
  end
end

def import_district_geoms
  RGeo::Shapefile::Reader.open(Rails.root.join(
      'lib', 'shapefiles', 'us_congress_districts_122116', 'cb_2015_us_cd114_500k.shp'
  ).to_s) do |file|
    puts "File contains #{file.num_records} records."
    file.each do |record|
      puts "Record number #{record.index}:"
      district = District.find_by(full_code: record.attributes['GEOID'])
      district.update(geom: record.geometry)
      puts record.attributes
    end
  end
end

import_state_geoms

import_district_geoms
