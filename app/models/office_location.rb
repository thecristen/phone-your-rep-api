# frozen_string_literal: true
class OfficeLocation < ApplicationRecord
  belongs_to    :rep, foreign_key: :bioguide_id, primary_key: :bioguide_id
  has_many      :issues 
  geocoded_by   :city_state_zip
  before_create :geocode
  before_save   :geocode, if: :needs_geocoding?
  scope         :find_with_rep, ->(id) { where(id: id).includes(rep: :office_locations) }

  dragonfly_accessor :qr_code

  def set_lonlat
    self.lonlat = RGeo::Cartesian.factory.point(longitude, latitude)
  end

  def needs_geocoding?
    latitude.nil? || longitude.nil?
  end

  def geocode
    super
    set_lonlat
  end

  def add_qr_code_img
    self.qr_code      = RQRCode::QRCode.new(v_card, size: 22, level: :h).as_png(size: 360).to_string
    self.qr_code.name = "#{rep.last}_#{state}_#{zip}.png"
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

  def to_hash
    { office_id:    id,
      type:         office_type,
      building:     building,
      address:      address,
      suite:        suite,
      city:         city,
      state:        state,
      zip:          zip,
      phone:        phone,
      fax:          fax,
      hours:        hours,
      latitude:     latitude,
      longitude:    longitude,
      v_card_link:  v_card_link,
      qr_code_link: qr_code_link }
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
    if Rails.env.production?
      'https://s3.amazonaws.com/phone-your-rep-images/' +  qr_code_uid.split('/').last
    elsif Rails.env.development?
      "http://localhost:3000#{qr_code.url}"
    end
  end

  def make_vcard
    Vpim::Vcard::Maker.make2 do |maker|
      add_rep_name(maker)
      add_contact_form(maker)
      add_primary_phone(maker)
      add_primary_address(maker)
      add_secondary_office(maker)
      maker.org = rep.role
    end
  end

  def add_secondary_office(maker)
    rep.office_locations.each do |office|
      next if office.office_type == office_type
      add_secondary_address(maker, office)
      add_secondary_phone(maker, office)
      break
    end
  end

  def add_secondary_phone(maker, office)
    return if office.phone.blank?
    maker.add_tel(office.phone) do |tel|
      tel.preferred  = false
      tel.location   = 'work'
      tel.capability = 'voice'
    end
  end

  def add_secondary_address(maker, office)
    maker.add_addr do |addr|
      addr.preferred  = false
      addr.location   = 'work'
      addr.street     = office.suite ? "#{office.address}, #{office.suite}" : office.address
      addr.locality   = office.city
      addr.region     = office.state
      addr.postalcode = office.zip
    end
  end

  def add_primary_address(maker)
    maker.add_addr do |addr|
      addr.preferred  = true
      addr.location   = 'work'
      addr.street     = suite ? "#{address}, #{suite}" : address
      addr.locality   = city
      addr.region     = state
      addr.postalcode = zip
    end
  end

  def add_contact_form(maker)
    return unless rep.contact_form
    maker.add_email(rep.contact_form) do |email|
      email.location  = 'work'
      email.preferred = true
    end
  end

  def add_primary_phone(maker)
    return if phone.blank?
    maker.add_tel(phone) do |tel|
      tel.preferred  = true
      tel.location   = 'work'
      tel.capability = 'voice'
    end
  end

  def add_rep_name(maker)
    maker.add_name do |name|
      name.prefix   = ''
      name.fullname = rep.official_full if rep.official_full
      name.given    = rep.first if rep.first
      name.family   = rep.last if rep.last
      name.suffix   = rep.suffix if rep.suffix
    end
  end
end
