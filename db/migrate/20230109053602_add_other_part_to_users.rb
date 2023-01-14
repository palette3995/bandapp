class AddOtherPartToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :other_part, :string
  end
end
