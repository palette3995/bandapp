class AddColumnUserParts < ActiveRecord::Migration[7.0]
  def change
    add_column :user_parts, :level, :string
  end
end
