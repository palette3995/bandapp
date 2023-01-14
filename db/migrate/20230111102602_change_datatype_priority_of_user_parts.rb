class ChangeDatatypePriorityOfUserParts < ActiveRecord::Migration[7.0]
  def change
    change_column :user_parts, :priority, :integer
  end
end
