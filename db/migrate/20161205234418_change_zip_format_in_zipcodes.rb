class ChangeZipFormatInZipcodes < ActiveRecord::Migration[5.0]
  def up
    change_column :zipcodes, :zip, :string
  end

  def down
    change_column :zipcodes, :zip, :integer
  end
end
