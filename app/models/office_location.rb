# frozen_string_literal: true
class OfficeLocation < ApplicationRecord
  belongs_to       :rep
  validates        :office_type, :line1, presence: true
  geocoded_by      :full_address
  after_validation :geocode, :set_lonlat
  scope            :find_with_rep, ->(id) { where(id: id).includes(rep: :office_locations) }

  def set_lonlat
    self[:lonlat] = RGeo::Cartesian.factory.point(longitude, latitude)
  end

  def full_address
    [line1, line2, city, state, zip].join(' ')
  end

  def to_hash
    { type:   office_type,
      line_1: line1,
      line_2: line2,
      city:   city,
      state:  state,
      zip:    zip,
      v_card_link: "localhost:3000/v_cards/#{id}"
    }
  end

  def make_vcard
    Vpim::Vcard::Maker.make2 do |maker|

      maker.add_name do |name|
        name.prefix = ''
        name.given  = rep.first_name
        name.family = rep.last_name
      end

      unless phone.blank?
        maker.add_tel(phone) do |tel|
          tel.preferred = true
          tel.location = 'work'
          tel.capability = 'voice'
        end
      end

      maker.add_addr do |addr|
        addr.preferred = true
        addr.location = 'work'
        addr.street = line2 ? "#{line1}, #{line2}" : line1
        addr.locality = city
        addr.region = state
        addr.postalcode = zip
      end

      rep.office_locations.each do |office|
        next if office == self
        maker.add_addr do |addr|
          addr.preferred = false
          addr.location = 'work'
          addr.street = office.line1 ? "#{office.line1}, #{office.line2}" : office.line1
          addr.locality = office.city
          addr.region = office.state
          addr.postalcode = office.zip
        end

        maker.add_tel(office.phone) do |tel|
          tel.preferred = false
          tel.location = 'work'
          tel.capability = 'voice'
        end
      end

      rep.email.each do |email|
        unless email.blank?
          maker.add_email(email) do |eml|
            eml.location = 'work'
          end
        end
      end

      maker.org = rep.office
    end
  end
end
