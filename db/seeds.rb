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

# loop through CSV file, convert each row to a hash. headers of file will be used as keys b/c of `headers: true` above
csv.each do |row|
  puts row.to_hash
end