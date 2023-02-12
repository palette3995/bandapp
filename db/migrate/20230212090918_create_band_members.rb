class CreateBandMembers < ActiveRecord::Migration[7.0]
  def change
    create_table :band_members do |t|
      t.references :user, foreign_key: true
      t.references :band, foreign_key: true
      t.string :part
      t.string :role
      t.timestamps
    end
  end
end
