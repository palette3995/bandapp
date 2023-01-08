class AddColumnMotivationToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :motivation, :string
  end
end
