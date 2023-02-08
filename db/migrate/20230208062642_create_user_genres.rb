class CreateUserGenres < ActiveRecord::Migration[7.0]
  def change
    create_table :user_genres do |t|
      t.references :user, foreign_key: true
      t.references :genre, foreign_key: true
      t.string :priority
      t.string :other_genre
      t.timestamps
    end
  end
end
