class CreateScouts < ActiveRecord::Migration[7.0]
  def change
    create_table :scouts do |t|
      t.references :user, foreign_key: true
      t.references :scouted_user, foreign_key: { to_table: :users }
      t.references :band, foreign_key: true
      t.references :scouted_band, foreign_key: { to_table: :bands }
      t.references :part, foreign_key: true
      t.references :scouted_part, foreign_key: { to_table: :parts }
      t.string :other_part
      t.string :scouted_other_part
      t.timestamps
    end
  end
end
