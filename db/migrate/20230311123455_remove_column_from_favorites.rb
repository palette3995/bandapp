class RemoveColumnFromFavorites < ActiveRecord::Migration[7.0]
  def change
    remove_column :favorites, :recruit_member_id, :bigint
    remove_column :favorites, :favorited_band_id, :bigint
  end
end
