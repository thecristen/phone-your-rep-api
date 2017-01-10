class ChangeRepsOfficeToRole < ActiveRecord::Migration[5.0]
  def change
    rename_column :reps, :office, :role
  end
end
