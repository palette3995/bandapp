class CreateUserParts < ActiveRecord::Migration[7.0]
  def change
    create_table :user_parts do |t|
      t.belongs_to :user
      t.belongs_to :part
      t.string :priority
      t.timestamps
    end
  end
end
