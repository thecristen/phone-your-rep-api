class AddZipcodeToReps < ActiveRecord::Migration[5.0]
  def change
    add_column :reps, :zipcode, :string
  end
end
