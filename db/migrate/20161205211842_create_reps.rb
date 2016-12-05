class CreateReps < ActiveRecord::Migration[5.0]
  def change
    create_table :reps do |t|
      t.string :state
      t.string :member_full
      t.string :last_name
      t.string :first_name
      t.string :party
      t.string :district_office_address_line_1
      t.string :district_address_line_2
      t.string :district_address_line_3
      t.string :district_tel
      t.string :dc_office_address
      t.string :dc_tel
      t.string :email
      t.string :website
      t.string :class
      t.string :bioguide_id
      t.string :photo

      t.timestamps
    end
  end
end
