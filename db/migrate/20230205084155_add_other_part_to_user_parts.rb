class AddOtherPartToUserParts < ActiveRecord::Migration[7.0]
  def change
    add_column :user_parts, :other_part, :string
  end
end
