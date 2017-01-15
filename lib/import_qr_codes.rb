require 'csv'
require_relative '../config/environment.rb'
i = 0
CSV.foreach(Rails.root.join('lib', 'qr_codes.csv')) do |row|
  next if row[0] == 'bioguide_id'
  o = OfficeLocation.where(
    bioguide_id: (row[0].blank? ? nil : row[0]),
    phone:       (row[1].blank? ? nil : row[1]),
    city:        (row[0].blank? ? nil : row[2]),
    zip:         (row[0].blank? ? nil : row[3]),
  ).first

  # o.update(qr_code_uid: row[4], qr_code_name: row[5])
  if o
    o.update(qr_code_uid: row[4], qr_code_name: row[5])
    puts o.rep.official_full
    puts row[4], row[5]
    puts i += 1
  end
end