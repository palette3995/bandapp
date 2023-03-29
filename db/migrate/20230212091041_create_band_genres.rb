class CreateBandGenres < ActiveRecord::Migration[7.0]
  def change
    create_table :band_genres do |t|
      t.references :band, foreign_key: true
      t.integer :genre_id
      t.string :priority
      t.string :other_genre
      t.timestamps
    end
  end
end
