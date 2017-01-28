# frozen_string_literal: true
require 'csv'
require_relative '../config/environment.rb'

def find_or_create_zcta(zcta_code)
  zcta = Zcta.find_by(zcta: zcta_code)
  if zcta
    zcta
  else
    z = Zcta.create(zcta: zcta_code)
    puts "Created new ZCTA #{zcta_code}"
    z
  end
end

def zcta_code(row)
  zcta5 = row['ZCTA5']
  case zcta5.size
  when 4
    '0' + zcta5
  when 3
    '00' + zcta5
  when 2
    '000' + zcta5
  else
    zcta5
  end
end

def seed_zctas(file)
  csv_zcta_text = File.read(file)
  csv_zctas = CSV.parse(csv_zcta_text, headers: true, encoding: 'ISO-8859-1')
  csv_zctas.each do |row|
    state_code = row['STATE'].size == 1 ? '0' + row['STATE'] : row['STATE']
    dis_cod    = row['CD'].size == 1 ? '0' + row['CD'] : row['CD']
    zcta_code  = zcta_code(row)
    district   = District.find_by(full_code: state_code + dis_cod)
    zcta       = find_or_create_zcta(zcta_code)
    unless district.blank?
      zcta.districts << district
      puts "Added district #{district.code} to ZCTA #{zcta_code}"
    end
  end
end

Zcta.destroy_all

zcta_files = Dir[Rails.root.join('lib', 'seeds', 'zcta_cd', '*')]
zcta_files.each { |file| seed_zctas(file) }

puts "There are now #{Zcta.count} ZCTAs in the database."
