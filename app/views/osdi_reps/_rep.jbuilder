# frozen_string_literal: true

json.given_name rep[:first]
json.family_name rep[:last]
json.additional_name rep[:middle]
json.party_identification rep[:party]
json.honorific_suffix rep[:suffix]
json.set! 'pyr:bioguide_id', rep[:bioguide_id]

json.set! 'pyr:official_full', rep[:official_full]
json.set! 'pyr:state', rep[:state]
json.set! 'pyr:district', rep[:district]
json.set! 'pyr:role', rep[:role]
json.set! 'pyr:senate_class', rep[:senate_class]
json.set! 'pyr:nickname', rep[:nickname]
json.set! 'pyr:contact_form', rep[:contact_form]
json.postal_addresses rep[:office_locations] do |ol|
  json.partial! 'office_location', ol: ol
end
json.set! '_links' do
  json._self do
    json.href "#{@pfx}/osdi/people/#{rep[:bioguide_id]}"
  end
end
