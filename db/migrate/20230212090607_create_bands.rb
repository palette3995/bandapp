class CreateBands < ActiveRecord::Migration[7.0]
  def change
    create_table :bands do |t|
      t.string :name
      t.text :introduction
      t.integer :prefecture_id, foreign_key: true
      t.string :original
      t.string :motivation
      t.string :image
      t.string :want_to_copy
      t.string :activity_time
      t.string :available_day
      t.string :frequency
      t.timestamps
    end
  end
end
