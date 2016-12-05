# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'csv'

csv_text = File.read(Rails.root.join('lib', 'seeds', 'us_senators_20161205.csv')) # reads file into local variable
csv = CSV.parse(csv_text, headers: true, encoding: 'ISO-8859-1') # parse the CSV for ruby, ignoring first line (headers)
puts csv # run rails db:seed to print data to terminal to test contents of the variable