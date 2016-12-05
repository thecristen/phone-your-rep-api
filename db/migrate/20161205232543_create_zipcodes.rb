class CreateZipcodes < ActiveRecord::Migration[5.0]
  def change
    create_table :zipcodes do |t|
      t.integer :zip
      t.string :state

      t.timestamps
    end
  end
end
