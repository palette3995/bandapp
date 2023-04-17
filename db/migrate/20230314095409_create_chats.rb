class CreateChats < ActiveRecord::Migration[7.0]
  def change
    create_table :chats do |t|
      t.references :user, foreign_key: true, null: false
      t.references :band, foreign_key: true, null: false
      t.text :message
      t.timestamps
    end
  end
end
