class AddColumnToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :name, :string, null: false
    add_column :users, :age, :integer
    add_column :users, :sex, :string
    add_column :users, :favorite, :string
    add_column :users, :introduction, :text
    add_column :users, :image, :string
    add_column :users, :movie, :string
    add_column :users, :sound, :string
    add_column :users, :original, :string
    add_column :users, :want_to_copy, :string
    add_column :users, :motivation, :string
    add_column :users, :prefecture_id, :integer, foreign_key: true
    add_column :users, :frequency, :string
    add_column :users, :activity_time, :string
    add_column :users, :available_day, :string
    add_column :users, :compose, :boolean, default: false
  end
end
