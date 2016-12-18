class CreateReps < ActiveRecord::Migration[5.0]
  def change
    create_table :reps do |t|
      t.string :state
      t.string :district
      t.string :office
      t.string :member_full
      t.string :name
      t.string :last_name
      t.string :first_name
      t.string :party
      t.string :district_address_line_1
      t.string :district_address_line_2
      t.string :district_address_line_3
      t.string :district_tel
      t.string :capitol_address_line_1
      t.string :capitol_address_line_2
      t.string :capitol_address_line_3
      t.string :capitol_tel
      t.text :email
      t.string :url
      t.string :twitter
      t.string :facebook
      t.string :youtube
      t.string :googleplus
      t.text   :committees
      t.string :senate_class
      t.string :bioguide_id
      t.string :photo

      t.timestamps
    end
  end
end
