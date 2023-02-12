class AddPrefectureIdToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :prefecture_id, :integer, foreign_key: true
  end
end
