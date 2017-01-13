# frozen_string_literal: true
class OfficeLocation < ApplicationRecord
  belongs_to    :rep, foreign_key: :bioguide_id, primary_key: :bioguide_id
  geocoded_by   :city_state_zip
  before_create :geocode
  before_save   :geocode, if: :needs_geocoding?
  scope         :find_with_rep, ->(id) { where(id: id).includes(rep: :office_locations) }

  dragonfly_accessor :qr_code

  def set_lonlat
    self.lonlat = RGeo::Cartesian.factory.point(longitude, latitude)
  end

  def needs_geocoding?
    latitude == nil || longitude == nil
  end

  def geocode
    super
    set_lonlat
  end

  def add_qr_code_img
    qr_code_img = RQRCode::QRCode.new(v_card, :size => 22, :level => :h).as_png(
        resize_gte_to: false,
        resize_exactly_to: false,
        fill: 'white',
        color: 'black',
        size: 360,
        border_modules: 4,
        module_px_size: 6,
        file: nil # path to write
    )
    update_attribute :qr_code, qr_code_img.to_string
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
    { type:         office_type,
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
    "https://phone-your-rep.herokuapp.com/v_cards/#{id}" # TODO: change to production path for deployment
  end

  def make_vcard
    Vpim::Vcard::Maker.make2 do |maker|

      maker.add_name do |name|
        name.prefix   = ''
        name.fullname = rep.official_full if rep.official_full
        name.given    = rep.first if rep.first
        name.family   = rep.last if rep.last
        name.suffix   = rep.suffix if rep.suffix
      end

      unless phone.blank?
        maker.add_tel(phone) do |tel|
          tel.preferred  = true
          tel.location   = 'work'
          tel.capability = 'voice'
        end
      end

      if rep.contact_form
        maker.add_email(rep.contact_form) do |email|
          email.location  = 'work'
          email.preferred = true
        end
      end

      maker.add_addr do |addr|
        addr.preferred  = true
        addr.location   = 'work'
        addr.street     = suite ? "#{address}, #{suite}" : address
        addr.locality   = city
        addr.region     = state
        addr.postalcode = zip
      end

      rep.office_locations.each do |office|
        next if office.office_type == self.office_type
        maker.add_addr do |addr|
          addr.preferred = false
          addr.location = 'work'
          addr.street = office.suite ? "#{office.address}, #{office.suite}" : office.address
          addr.locality = office.city
          addr.region = office.state
          addr.postalcode = office.zip
        end

        unless office.phone.blank?
          maker.add_tel(office.phone) do |tel|
            tel.preferred  = false
            tel.location   = 'work'
            tel.capability = 'voice'
          end
        end

        break
      end

      maker.org = rep.role
    end
  end
end
