class RemoveRegionFromUsers < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :region, :string
  end
end
