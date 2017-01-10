# frozen_string_literal: true
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'csv'
def seed_states
  csv_state_text = File.read(Rails.root.join('lib', 'seeds', 'states.csv'))
  csv_states = CSV.parse(csv_state_text, headers: true, encoding: 'ISO-8859-1')
  csv_states.each do |row|
    s = State.new
    s.state_code = row['state_code']
    s.name       = row['name']
    s.abbr       = row['abbr']
    s.save
    puts "#{s.name} saved in database."
  end
  puts "There are now #{State.count} states in the database."
end

def seed_districts
  csv_district_text = File.read(Rails.root.join('lib', 'seeds', 'districts.csv'))
  csv_districts = CSV.parse(csv_district_text, headers: true, encoding: 'ISO-8859-1')
  csv_districts.each do |row|
    d = District.new
    d.code       = row['code']
    d.state_code = row['state_code']
    d.full_code  = row['full_code']
    d.save
    puts "District #{d.code} of #{d.state.name} saved in database."
  end
  puts "There are now #{District.count} districts in the database."
end

def seed_reps
  csv_rep_text = File.read(Rails.root.join('lib', 'seeds', 'reps_20161226.csv'))
  csv_reps = CSV.parse(csv_rep_text, headers: true, encoding: 'ISO-8859-1')
  csv_reps.each do |row|
    state    = State.find_by(abbr: row['state_and_district'].match(/[A-Z]{2}/).to_s)
    district = District.where(state_code: state.state_code, code: row['state_and_district'].match(/[0-9]{2}/).to_s))
    r              = Rep.new
    r.state        = state
    r.district     = district
    r.office       = 'United States House Representative'
    r.member_full  = row['member_full']
    r.name         = row['name']
    r.last_name    = row['last_name']
    r.first_name   = row['first_name']
    r.middle_name  = row['middle_name']
    r.suffix       = row['suffix']
    r.party        = row['party']
    r.email        = [row['email']]
    r.website      = row['website']
    r.twitter      = row['twitter']
    r.facebook     = row['facebook']
    r.youtube      = row['youtube']
    r.googleplus   = row['googleplus']
    r.committees   = [row['committees']]
    r.senate_class = row['senate_class']
    r.bioguide_id  = row['bioguide_id']
    r.photo        = row['Photo']
    r.save
    puts "#{r.name}, #{r.office}, #{r.state.name} saved in database."
  end
  puts "There are now #{Rep.count} reps in the database."
end

def seed_sens
  csv_sen_text = File.read(Rails.root.join('lib', 'seeds', 'reps_20161226.csv'))
  csv_sens = CSV.parse(csv_sen_text, headers: true, encoding: 'ISO-8859-1')
  csv_sens.each do |row|
    name_array     = [row['first_name'].split(', ')[0].split(' ')[0],
                      row['first_name'].split(', ')[0].split(' ')[1],
                      row['last_name']]
    suffix         = row['first_name'].split(', ')[1]
    state          = State.find_by(abbr: row['state'])
    r              = Rep.new
    r.state        = state
    r.office       = 'United States Senate'
    r.member_full  = row['member_full']
    r.last_name    = name_array[2]
    r.first_name   = name_array[0]
    r.middle_name  = name_array[1]
    r.suffix       = suffix
    r.name         = suffix ? "#{[name_array - [nil]].join(' ')}, #{suffix}" : [name_array - [nil]].join(' ')
    r.party        = row['party']
    r.email        = [row['email']]
    r.website      = row['website']
    r.twitter      = row['twitter']
    r.facebook     = row['facebook']
    r.youtube      = row['youtube']
    r.googleplus   = row['googleplus']
    r.committees   = [row['committees']]
    r.senate_class = row['senate_class']
    r.bioguide_id  = row['bioguide_id']
    r.photo        = row['photo']
    r.save
    puts "#{r.name}, #{r.office}, #{r.state.name} saved in database."
  end
  puts "There are now #{Rep.count} reps in the database."
end

def seed_rep_office_locations
  csv_office_location_text = File.read(Rails.root.join('lib', 'seeds', 'office_locations_20161226.csv'))
  csv_office_locations = CSV.parse(csv_office_location_text, headers: true, encoding: 'ISO-8859-1')
  csv_office_locations.each do |row|
    rep           = Rep.find_by(member_full: row['rep_full'])
    o             = OfficeLocation.new
    o.type        = row['type']
    o.office_name = row['office_name']
    o.line1       = row['line1']
    o.line2       = row['line2']
    o.city        = row['city']
    o.state       = row['state']
    o.zip         = row['zip']
    o.phones      = [row['phone_1'], row['phone_2'], row['phone_3'], row['phone_4']] - [nil]
    o.rep         = rep
    o.save
    puts "#{o.rep.name}'s #{o.office_type} office saved in database."
  end
  puts "There are now #{OfficeLocation.count} office locations in the database."
end

def seed_sen_office_locations
  csv_office_location_text = File.read(Rails.root.join('lib', 'seeds', 'office_locations_20161226.csv'))
  csv_office_locations = CSV.parse(csv_office_location_text, headers: true, encoding: 'ISO-8859-1')
  csv_office_locations.each do |row|
    rep           = Rep.find_by(member_full: row['member_full'])
    line_3        = row['district_office_line_3'].split(', ')
    city          = line_3.shift
    d             = OfficeLocation.new
    d.type        = 'district'
    d.office_name = "#{city} Office"
    d.line1       = row['district_office_line_1']
    d.line2       = row['district_office_line_2']
    d.city        = city
    d.state       = line_3.split(' ')[0]
    d.zip         = line_3.split(' ')[1]
    d.phones      = [row[district_phone]]
    d.rep         = rep
    d.save

    c             = OfficeLocation.new
    c.type        = 'capitol'
    c.office_name = "Washington D.C. Office"
    c.line1       = row['capitol_office_line_1']
    c.city        = capitol_city
    c.state       = capitol_state
    c.zip         = capitol_zip
    c.phones      = [row[capitol_phone]]
    c.rep         = rep
    puts "#{rep.name}'s #{d.office_type} and #{c.office_type} office(s) saved in database."
  end
  puts "There are now #{OfficeLocation.count} office locations in the database."
end

seed_states
seed_districts
seed_reps
seed_sens
seed_rep_office_locations
seed_sen_office_locations
