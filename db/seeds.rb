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
    r = Rep.new
    r.id = row['id']
    r.district_id  = row['district_id']
    r.state_id     = row['state_id']
    r.office       = row['office']
    r.name         = row['name']
    r.last_name    = row['last_name']
    r.first_name   = row['first_name']
    r.party        = row['party']
    r.email        = [row['email'].gsub("---\n- ", '').gsub("\n", '')] if row['email']
    r.url          = row['url']
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

def seed_office_locations
  csv_office_location_text = File.read(Rails.root.join('lib', 'seeds', 'office_locations_20161226.csv'))
  csv_office_locations = CSV.parse(csv_office_location_text, headers: true, encoding: 'ISO-8859-1')
  csv_office_locations.each do |row|
    o = OfficeLocation.new
    o.id          = row['id']
    o.rep_id      = row['rep_id']
    o.office_type = row['office_type']
    o.line1       = row['line1']
    o.line2       = row['line2']
    o.city        = row['city']
    o.state       = row['state']
    o.zip         = row['zip']
    o.latitude    = row['latitude']
    o.longitude   = row['longitude']
    o.phone       = row['phone']
    o.save
    puts "#{o.rep.name}'s #{o.office_type} office saved in database."
  end
  puts "There are now #{OfficeLocation.count} office locations in the database."
end

seed_states
seed_districts
seed_reps
seed_office_locations
