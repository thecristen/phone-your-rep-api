# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
100000.times do |rep|
  rep = Rep.new
  rep.name    = Faker::Name.name
  rep.phone   = Faker::PhoneNumber.phone_number
  rep.zipcode = Faker::Address.zip

  rep.save
end
