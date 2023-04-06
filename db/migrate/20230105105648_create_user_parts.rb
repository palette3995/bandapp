class CreateUserParts < ActiveRecord::Migration[7.0]
  def change
    create_table :user_parts do |t|
      t.belongs_to :user
      t.integer :part_id
      t.integer :priority
      t.string :other_part
      t.integer :level
      t.timestamps
    end
  end
end
