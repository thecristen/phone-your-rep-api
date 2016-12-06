class AddCityToZipcodes < ActiveRecord::Migration[5.0]
  def change
    add_column :zipcodes, :city, :string
  end
end
