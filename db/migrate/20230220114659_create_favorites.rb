class CreateFavorites < ActiveRecord::Migration[7.0]
  def change
    create_table :favorites do |t|
      t.references :user, foreign_key: true
      t.references :favorited_user, foreign_key: { to_table: :users }
      t.references :band, foreign_key: true
      t.references :favorited_band, foreign_key: { to_table: :bands }
      t.references :recruit_member, foreign_key: true
      t.timestamps
    end
  end
end
