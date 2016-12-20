class AddPhoneToOfficeLocation < ActiveRecord::Migration[5.0]
  def change
    add_column :office_locations, :phone, :string
  end
end
