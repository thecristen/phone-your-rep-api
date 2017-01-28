# frozen_string_literal: true
require 'csv'
require_relative '../config/environment.rb'

def seed_zctas(file)
  csv_zcta_text = File.read(file)
  csv_zctas = CSV.parse(csv_zcta_text, headers: true, encoding: 'ISO-8859-1')
  csv_zctas.each do |row|
    state_code = row['State'].size == 1 ? '0' + row['State'] : row['State']
    puts state_code
    dis_cod = row['CongressionalDistrict'].size == 1 ? '0' + row['CongressionalDistrict'] : row['CongressionalDistrict']
    puts dis_cod
    district = District.find_by(full_code: state_code + dis_cod)
    zcta = Zcta.find_by(zcta: row['ZCTA'])
    if zcta
      zcta.districts << district
      puts "Added district #{district.full_code} to ZCTA #{zcta.zcta}"
    else
      Zcta.create do |z|
        z.zcta = row['ZCTA']
        z.districts << district
      end
      puts "Created ZCTA #{row['ZCTA']}, and added district #{district.full_code}"
    end
  end
end

Zcta.destroy_all

zcta_files = Dir[Rails.root.join('lib', 'seeds', 'zcta_cd', '*')]
zcta_files.each { |file| seed_zctas(file) }
