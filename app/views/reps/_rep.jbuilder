# frozen_string_literal: true

json.self          "#{@pfx}/reps/#{rep.bioguide_id}"
json.bioguide_id   rep.bioguide_id
json.official_full rep.official_full

json.state do
  json.partial! 'states/state', state: rep.state
end

json.district do
  json.partial! 'districts/district', district: rep.district if rep.district
end

json.role         rep.role
json.party        rep.party
json.senate_class rep.senate_class
json.last         rep.last
json.first        rep.first
json.middle       rep.middle
json.nickname     rep.nickname
json.suffix       rep.suffix
json.contact_form rep.contact_form
json.url          rep.url
json.photo        rep.photo
json.twitter      rep.twitter
json.facebook     rep.facebook
json.youtube      rep.youtube
json.instagram    rep.instagram
json.googleplus   rep.googleplus
json.twitter_id   rep.twitter_id
json.facebook_id  rep.facebook_id
json.youtube_id   rep.youtube_id
json.instagram_id rep.instagram_id

json.set! 'office_locations', rep.sorted_offices_array do |office|
  json.partial! 'office_locations/office_location', office: office
end
