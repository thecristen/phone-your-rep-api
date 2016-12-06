class RenameRepsClassColumn < ActiveRecord::Migration[5.0]
  def change
    rename_column :reps, :class, :senate_class
  end
end
