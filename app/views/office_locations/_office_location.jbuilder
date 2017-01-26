# frozen_string_literal: true

json.id              office.id
json.rep_bioguide_id office.bioguide_id
json.type            office.office_type
json.distance        office.distance if office.distance
json.building        office.building
json.address         office.address
json.suite           office.suite
json.city            office.city
json.state           office.state
json.zip             office.zip
json.phone           office.phone
json.fax             office.fax
json.hours           office.hours
json.latitude        office.latitude
json.longitude       office.longitude
json.v_card_link     office.v_card_link
json.qr_code_link    office.qr_code_link
