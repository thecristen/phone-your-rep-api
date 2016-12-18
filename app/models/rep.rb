class Rep < ApplicationRecord

  serialize :committees, Array
  serialize :email, Array

  def self.get_all_reps(address)
    @reps = GetYourRep.all(address)
    @db_reps = self.where(last_name: @reps.last_names, first_name: @reps.first_names)
    update_rep_info_from_db
    @reps
  end

  def self.update_rep_info_from_db
    @reps.each do |rep|
      db_rep = @db_reps.select { |db_rep| db_rep.last_name == rep.last_name }.first

      if db_rep.blank?
        add_rep_to_db(rep)
        next
      end

      rep.phone.unshift(db_rep.district_tel)  if rep.phone.size < 2 && db_rep.district_tel
      rep.email += (db_rep.email).flatten if rep.email.size < 1 && db_rep.email

      if rep.district_office.empty?
        rep.office_locations.unshift Hash[
          :type, 'district',
          :line_1, db_rep.district_address_line_1,
          :line_2, db_rep.district_address_line_2,
          :line_3, db_rep.district_address_line_3
        ]
      end

      update_rep_info_to_db(rep, db_rep)
    end
  end

  def self.add_rep_to_db(rep)
    parse_new_rep_office(rep)
    new_rep  = Rep.new
    new_rep.state                   = @rep_data[:state]
    new_rep.district                = @rep_data[:district]
    new_rep.office                  = rep.office
    new_rep.name                    = rep.name
    new_rep.last_name               = rep.last_name
    new_rep.first_name              = rep.first_name
    new_rep.party                   = rep.party
    new_rep.district_address_line_1 = rep.district_office[:line_1]
    new_rep.district_address_line_2 = rep.district_office[:line_2]
    new_rep.district_address_line_3 = rep.district_office[:line_3]
    new_rep.district_tel            = rep.phone.first if rep.phone.size > 1
    new_rep.capitol_address_line_1  = rep.capitol_office[:line_1]
    new_rep.capitol_address_line_2  = rep.capitol_office[:line_2]
    new_rep.capitol_address_line_3  = rep.capitol_office[:line_3]
    new_rep.capitol_tel             = rep.phone.last
    new_rep.email                   = rep.email
    new_rep.url                     = rep.url
    new_rep.twitter                 = rep.twitter
    new_rep.facebook                = rep.facebook
    new_rep.youtube                 = rep.youtube
    new_rep.googleplus              = rep.googleplus
    new_rep.photo                   = rep.photo
    new_rep.committees              = rep.committees
    new_rep.save
    puts "Saved #{new_rep.name}, #{new_rep.office} in database."
  end

  def self.parse_new_rep_office(rep)
    @rep_data = {}
    if rep.office.downcase.match(/(united states house)/)
      office_suffix        = rep.office.split(' ').last
      @rep_data[:state]    = office_suffix.split('-').first
      @rep_data[:district] = office_suffix.split('-').last
    elsif rep.office.downcase.match(/upper|lower|chamber/)
      office_array         = rep.office.split(' ')
      @rep_data[:state]    = office_array.first
      @rep_data[:district] = office_array.last
    end
  end

  def self.update_rep_info_to_db(rep, db_rep)
    @update_params = {}
    @update_params[:office] = rep.office if db_rep.office != rep.office
    @update_params[:party]  = rep.party  if db_rep.party  != rep.party
    update_email(rep, db_rep)
    update_social_handles(rep, db_rep)
    update_capitol_address(rep, db_rep)
    update_committees(rep, db_rep)
    db_rep.update(@update_params) unless @update_params.blank?
  end

  def self.update_email(rep, db_rep)
    unless (rep.email - db_rep.email).empty?
      @update_params[:email] = (db_rep.email += rep.email)
    end
  end

  def self.update_social_handles(rep, db_rep)
    @update_params[:twitter]    = rep.twitter    if db_rep.twitter    != rep.twitter
    @update_params[:facebook]   = rep.facebook   if db_rep.facebook   != rep.facebook
    @update_params[:youtube]    = rep.youtube    if db_rep.youtube    != rep.youtube
    @update_params[:googleplus] = rep.googleplus if db_rep.googleplus != rep.googleplus
  end

  def self.update_capitol_address(rep, db_rep)
    return unless rep.capitol_office

    if db_rep.capitol_address_line_1 != rep.capitol_office[:line_1]
      @update_params[:capitol_address_line_1] = rep.capitol_office[:line_1]
    end

    if db_rep.capitol_address_line_2 != rep.capitol_office[:line_2]
      @update_params[:capitol_address_line_2] = rep.capitol_office[:line_2]
    end

    if db_rep.capitol_address_line_3 != rep.capitol_office[:line_3]
      @update_params[:capitol_address_line_3] = rep.capitol_office[:line_3]
    end
  end

  def self.update_committees(rep, db_rep)
    unless rep.committees.nil? || (rep.committees - db_rep.committees).empty?
      @update_params[:committees] = (db_rep.committees += rep.committees)
    end
  end

  def self.random_rep
    random_rep = Rep.order("RANDOM()").limit(1).first
    return Hash[:error, 'Something went wrong, try again.'].to_a if random_rep.nil?
    GetYourRep::Representative[
      :name,      random_rep.name,
      :office,    random_rep.office,
      :party,     party(random_rep.party),
      :phone,     [random_rep.district_tel, random_rep.capitol_tel] - [nil],
      :office_locations, [
        {
        type: 'district',
        line_1: random_rep.district_address_line_1,
        line_2: random_rep.district_address_line_2,
        line_3: random_rep.district_address_line_3
        },
        {
        type: 'capitol',
        line_1: random_rep.capitol_address_line_1,
        line_2: random_rep.capitol_address_line_2,
        line_3: random_rep.capitol_address_line_3
        }
      ],
      :email,      random_rep.email,
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
