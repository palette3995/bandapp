class RemovePartFromUsers < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :part, :string
  end
end
