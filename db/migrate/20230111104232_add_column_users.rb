class AddColumnUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :frequency, :string
    add_column :users, :activity_time, :string
    add_column :users, :available_day, :string
    add_column :users, :compose, :boolean, default: false
  end
end
