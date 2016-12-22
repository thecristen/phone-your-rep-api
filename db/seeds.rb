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
  r.state = State.where(abbr: row.first.last).first # row['State'] returns nil for some reason. This is a hack.
  r.member_full = row['Member Full']
  r.name = "#{row['First Name']} #{row['Last Name']}"
  r.office = "United States Senate"
  r.last_name = row['Last Name']
  r.first_name = row['First Name']
  r.party = row['Party']
  r.email = [row['Email']]
  r.url = row['Website']
  r.senate_class = row['Class']
  r.bioguide_id = row['bioguide_id']
  r.photo = row['Photo']
  d_o = r.office_locations.build
  d_o.office_type = 'district'
  d_o.line1 = row['District Office Address Line 1']
  d_o.line2 = row['District Address Line 2']
  d_o.line3 = row['District Address Line 3']
  d_o.phone = row['District Tel #']
  c_o = r.office_locations.build
  c_o.office_type = 'capitol'
  c_o.line1 = row['DC Office Address']
  c_o.line2 = "Washington, DC 20002"
  c_o.phone = row['DC Tel #']
  r.save
  puts "#{r.member_full} saved in database.\nOffice locations:\n#{d_o.office_type}: #{d_o.line1}, #{d_o.line2}, #{d_o.line3}\n#{c_o.office_type}: #{c_o.line1}"
end

# loop through zipcodes CSV file, seed database with zips
# csv_zipcode_text = File.read(Rails.root.join('lib', 'seeds', 'zipcodes_20161205.csv'))
# csv_zipcode = CSV.parse(csv_zipcode_text, headers: true, encoding: 'ISO-8859-1')
# csv_zipcode.each do |row|
#   z = Zipcode.new
#   z.zip = row['Zipcode']
#   z.state = row['State']
#   z.city = row['City']
#   z.save
#   puts "#{z.zip} #{z.city}, #{z.state} saved in database."
# end

puts "There are now #{Rep.count} reps and #{OfficeLocation.count} office locations in the database."
# puts "There are now #{Zipcode.count} zipcodes in the database."
