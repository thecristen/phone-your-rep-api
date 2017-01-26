# frozen_string_literal: true
require 'csv'
require_relative '../config/environment.rb'

i = 0
CSV.foreach(Rails.root.join('lib', 'qr_codes.csv')) do |row|
  next if row[0] == 'id'
  o = OfficeLocation.find(row[0])
  # o.update(qr_code_uid: row[4], qr_code_name: row[5])
  if o
    o.update(qr_code_uid: row[1], qr_code_name: row[2])
    puts o.rep.official_full
    puts row[1], row[2]
    puts i += 1
  end
end
