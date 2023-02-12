class RemoveGenreFromUsers < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :genre, :string
  end
end
