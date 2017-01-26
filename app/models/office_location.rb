# frozen_string_literal: true
class OfficeLocation < ApplicationRecord
  include VCardable

  belongs_to    :rep, foreign_key: :bioguide_id, primary_key: :bioguide_id
  has_many      :issues

  geocoded_by      :city_state_zip
  after_validation :geocode, if: :needs_geocoding?
  scope            :find_with_rep, ->(id) { where(id: id).includes(rep: :office_locations) }

  dragonfly_accessor :qr_code
  attr_reader        :distance

  FACTORY = RGeo::Geographic.simple_mercator_factory

  def set_lonlat
    update lonlat: FACTORY.point(longitude, latitude)
  end

  def needs_geocoding?
    latitude.blank? || longitude.blank?
  end

  def geocode
    super
    set_lonlat
  end

  def add_qr_code_img
    self.qr_code = RQRCode::QRCode.new(v_card, size: 22, level: :h).as_png(size: 360).to_string
    qr_code.name = "#{rep.last}_#{office_type}_#{id}.png"
    save
  end

  def add_v_card
    v_card = make_vcard
    update_attribute :v_card, v_card.to_s
  end

  def full_address
    "#{address}, #{city_state_zip}"
  end

  def city_state_zip
    [city, state, zip].join(' ')
  end

  def calculate_distance(coordinates)
    return if needs_geocoding?
    @distance = Geocoder::Calculations.distance_between(coordinates, [latitude, longitude]).round(1)
  end

  def v_card_link
    if Rails.env.production?
      "https://phone-your-rep.herokuapp.com/v_cards/#{id}"
    elsif Rails.env.development?
      "http://localhost:3000/v_cards/#{id}"
    end
  end

  def qr_code_link
    return if qr_code.blank?
    "https://s3.amazonaws.com/phone-your-rep-images/#{qr_code_uid.split('/').last}" if qr_code_uid
  end
end
