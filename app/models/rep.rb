class Rep < ApplicationRecord

  def self.get_all_reps(address)
    @reps = GetYourRep.all(address)
    @db_reps = self.where(last_name: @reps.last_names, first_name: @reps.first_names)
    update_district_info
    @reps
  end

  def self.update_district_info
    @reps.each do |rep|
      db_rep = @db_reps.select { |db_rep| db_rep.last_name == rep.last_name }
      next if db_rep.blank?
      rep.phone.unshift(db_rep[0].district_tel)
      rep.email.unshift(db_rep[0].email)
      rep.office_locations.unshift Hash[
        :type, 'district',
        :line_1, db_rep[0].district_office_address_line_1,
        :line_2, db_rep[0].district_address_line_2,
        :line_3, db_rep[0].district_address_line_3
      ]
    end
  end

  def self.random_rep
    random_zip = Zipcode.random_zip
    random_rep = Rep.find_by(state: random_zip.state)
    return Hash[:error, 'Something went wrong, try again.'].to_a if random_rep.nil?
    GetYourRep::Representative[
      :name,      "#{random_rep.first_name} #{random_rep.last_name}",
      :office,    "United States Senate, #{random_rep.state}",
      :party,     party(random_rep.party),
      :phone,     [random_rep.district_tel, random_rep.dc_tel],
      :office_locations, [
        {
        type: 'district',
        line_1: random_rep.district_office_address_line_1,
        line_2: random_rep.district_address_line_2,
        line_3: random_rep.district_address_line_3
        },
        {
        type: 'capitol',
        line_1: random_rep.dc_office_address
        }
      ],
      :email,     [random_rep.email],
      :url,       random_rep.website,
      :photo,     random_rep.photo,
    ].to_del
  end

  def self.party(value)
    case value
    when 'D'
      'Democratic'
    when 'R'
      'Republican'
    when 'I'
      'Independent'
    else
      value
    end
  end
end
