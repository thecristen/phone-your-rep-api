class Rep < ApplicationRecord

  def self.get_all_reps(address)
    @reps = GetYourRep.all(address)
    @db_reps = self.where(last_name: @reps.last_names, first_name: @reps.first_names)
    update_rep_info_from_db
    @reps
  end

  def self.update_rep_info_from_db
    @reps.each do |rep|
      db_rep = @db_reps.select { |db_rep| db_rep.last_name == rep.last_name }.first
      next if db_rep.blank?
      rep.phone.unshift(db_rep.district_tel)
      rep.email.unshift(db_rep.email)
      rep.office_locations.unshift Hash[
        :type, 'district',
        :line_1, db_rep.district_address_line_1,
        :line_2, db_rep.district_address_line_2,
        :line_3, db_rep.district_address_line_3
      ]
      update_rep_info_to_db(rep, db_rep)
    end
  end

  def self.update_rep_info_to_db(rep, db_rep)
    update_params = {}
    update_params[:twitter]    = rep.twitter    if db_rep.twitter.nil?    && rep.twitter
    update_params[:facebook]   = rep.facebook   if db_rep.facebook.nil?   && rep.facebook
    update_params[:youtube]    = rep.youtube    if db_rep.youtube.nil?    && rep.youtube
    update_params[:googleplus] = rep.googleplus if db_rep.googleplus.nil? && rep.googleplus
    db_rep.update(update_params) unless update_params.blank?
  end

  def self.random_rep
    random_rep = Rep.order("RANDOM()").limit(1).first
    return Hash[:error, 'Something went wrong, try again.'].to_a if random_rep.nil?
    GetYourRep::Representative[
      :name,      random_rep.name,
      :office,    "United States Senate, #{random_rep.state}",
      :party,     party(random_rep.party),
      :phone,     [random_rep.district_tel, random_rep.dc_tel],
      :office_locations, [
        {
        type: 'district',
        line_1: random_rep.district_address_line_1,
        line_2: random_rep.district_address_line_2,
        line_3: random_rep.district_address_line_3
        },
        {
        type: 'capitol',
        line_1: random_rep.dc_office_address
        }
      ],
      :email,      [random_rep.email],
      :url,        random_rep.url,
      :photo,      random_rep.photo,
      :twitter,    random_rep.twitter,
      :facebook,   random_rep.facebook,
      :youtube,    random_rep.youtube,
      :googleplus, random_rep.googleplus
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
