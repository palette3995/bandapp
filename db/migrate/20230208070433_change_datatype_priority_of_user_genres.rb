class ChangeDatatypePriorityOfUserGenres < ActiveRecord::Migration[7.0]
  def change
    change_column :user_genres, :priority, :integer
  end
end
