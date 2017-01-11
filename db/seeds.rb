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
  @reps.each do |rep|
    name = rep['name']
    term = rep['terms'].last
    address_ary = term['address'].split(' ')
    dis_code = format('%d', term['district']) if term['district']
    dis_code = dis_code.size == 1 ? "0#{dis_code}" : dis_code if dis_code
    r = Rep.new
    r.bioguide_id   = rep['id']['bioguide']
    r.official_full = name['official_full']
    r.first         = name['first']
    r.middle        = name['middle']
    r.last          = name['last']
    r.suffix        = name['suffix']
    r.nickname      = name['nickname']
    r.role          = if term['type'] == 'sen'
                        'United States Senate'
                      elsif term['type'] == 'rep'
                        'United States Representative'
                      else
                        term['type']
                      end
    r.state         = State.find_by(abbr: term['state'])
    r.district      = District.where(code: dis_code, state: r.state).first if term['district']
    r.party         = term['party']
    r.url           = term['url']
    r.contact_form  = term['contact_form']
    r.senate_class  = format('0%o', term['class']) if term['class']
    r.office_locations.build(
                          office_type: 'capitol',
                          zip: address_ary.pop,
                          state: address_ary.pop,
                          city: address_ary.pop,
                          address: address_ary.join(' ').gsub(';', ''),
                          phone: term['phone'],
                          fax: term['fax'],
                          hours: term['hours']
    )
    r.save
    puts "#{r.official_full} saved in the database."
  end
  puts "There are now #{Rep.count} reps and #{OfficeLocation.count} office locations in the database."
end

def seed_socials
  @socials.each do |social|
    rep = Rep.find_by(bioguide_id: social['id']['bioguide'])
    rep.facebook     = social['social']['facebook']
    rep.facebook_id  = social['social']['facebook_id']
    rep.twitter      = social['social']['twitter']
    rep.twitter_id   = social['social']['twitter_id']
    rep.youtube      = social['social']['youtube']
    rep.youtube_id   = social['social']['youtube_id']
    rep.instagram    = social['social']['instagram']
    rep.instagram_id = social['social']['instagram_id']
    rep.googleplus   = social['social']['googleplus']
    rep.save
  end
end

def seed_office_locations
  @offices.each do |office|
    rep = Rep.find_by(bioguide_id: office['id']['bioguide'])
    next if rep.blank?
    office['offices'].each do |off|
      rep.office_locations.build(
                              office_type: 'district',
                              suite: off['suite'],
                              phone: off['phone'],
                              address: off['address'],
                              building: off['building'],
                              city: off['city'],
                              state: off['state'],
                              zip: off['zip'],
                              fax: off['fax'],
                              hours: off['hours']
      )
      rep.save
      puts "#{rep.official_full}'s office location saved to the database."
    end
  end
  puts "There are now #{OfficeLocation.count} office locations in the database."
end
# seed_states
# seed_districts
seed_reps
seed_socials
seed_office_locations
