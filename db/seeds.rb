# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'csv'

# reads file into local variable
csv_senator_text = File.read(Rails.root.join('lib', 'seeds', 'us_senators_20161205.csv'))

# parse the CSV for ruby, ignoring first line (headers)
csv_senate = CSV.parse(csv_senator_text, headers: true, encoding: 'ISO-8859-1')

# loop through senators CSV file, seed database with reps
csv_senate.each do |row|
  r = Rep.new
  r.state = row.first.last # row['State'] returns nil for some reason. This is a hack.
  r.member_full = row['Member Full']
  r.last_name = row['Last Name']
  r.first_name = row['First Name']
  r.party = row['Party']
  r.district_office_address_line_1 = row['District Office Address Line 1']
  r.district_address_line_2 = row['District Address Line 2']
  r.district_address_line_3 = row['District Address Line 3']
  r.district_tel = row['District Tel #']
  r.dc_office_address = row['DC Office Address']
  r.dc_tel = row['DC Tel #']
  r.email = row['Email']
  r.website = row['Website']
  r.senate_class = row['Class']
  r.bioguide_id = row['bioguide_id']
  r.photo = row['Photo']
  r.save
  puts "#{r.member_full} saved in database."
end

# loop through zipcodes CSV file, seed database with zips
csv_zipcode_text = File.read(Rails.root.join('lib', 'seeds', 'zipcodes_20161205.csv'))
csv_zipcode = CSV.parse(csv_zipcode_text, headers: true, encoding: 'ISO-8859-1')
csv_zipcode.each do |row|
  z = Zipcode.new
  z.zip = row['Zipcode']
  z.state = row['State']
  z.city = row['City']
  z.save
  puts "#{z.zip} #{z.city}, #{z.state} saved in database."
end

puts "There are now #{Rep.count} reps in the database."
puts "There are now #{Zipcode.count} zipcodes in the database."
