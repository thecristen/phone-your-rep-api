# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'csv'

# reads file into local variable
csv_text = File.read(Rails.root.join('lib', 'seeds', 'us_senators_20161205.csv'))

# parse the CSV for ruby, ignoring first line (headers)
csv = CSV.parse(csv_text, headers: true, encoding: 'ISO-8859-1')

# loop through CSV file, seed database with reps
csv.each do |row|
  r = Rep.new
  r.state = row['State']
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

puts "There are now #{Rep.count} reps in the database."