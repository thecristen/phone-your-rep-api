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

def parse_yaml(file)
  YAML::load(File.open(Rails.root.join('lib', 'seeds', file)))
end

@offices = parse_yaml('legislators-district-offices.yaml')

@reps = parse_yaml('legislators-current.yaml')

@socials = parse_yaml('legislators-social-media.yaml')

def seed_reps

end
# seed_states
# seed_districts
seed_reps
seed_sens
seed_rep_office_locations
# seed_sen_office_locations
