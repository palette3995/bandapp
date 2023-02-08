class RemoveOtherPartFromUsers < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :other_part, :string
  end
end
