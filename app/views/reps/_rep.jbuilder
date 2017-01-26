# frozen_string_literal: true

json.self "#{@pfx}/reps/#{rep.bioguide_id}"
json.bioguide_id rep.bioguide_id
json.official_full rep.official_full
json.state  do
  json.state_code rep.state.state_code
  json.name rep.state.name
  json.abbr rep.state.abbr
end
if rep.district
  json.district do
    json.code rep.district.code
    json.full_code rep.district.full_code
  end
end

json.role rep.role
json.party rep.party
json.senate_class rep.senate_class
json.last rep.last
json.first rep.first
json.middle rep.middle
json.nickname rep.nickname
json.suffix rep.suffix
json.contact_form rep.contact_form
json.url rep.url
json.photo rep.photo
json.twitter rep.twitter
json.facebook rep.facebook
json.youtube rep.youtube
json.instagram rep.instagram
json.googleplus rep.googleplus
json.twitter_id rep.twitter_id
json.facebook_id rep.facebook_id
json.youtube_id rep.youtube_id
json.instagram_id rep.instagram_id
json.office_locations rep.sorted_offices_array