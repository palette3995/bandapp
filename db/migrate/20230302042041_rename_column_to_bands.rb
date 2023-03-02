class RenameColumnToBands < ActiveRecord::Migration[7.0]
  def change
    rename_column :bands, :avairable_day, :available_day
  end
end
