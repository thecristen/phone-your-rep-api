class AddMemberFullToReps < ActiveRecord::Migration[5.0]
  def change
    add_column :reps, :member_full, :string
  end
end
