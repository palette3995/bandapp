class ChangeDatatypeLevelOfUserParts < ActiveRecord::Migration[7.0]
  def change
    change_column :user_parts, :level, :integer
  end
end
