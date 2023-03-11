class RemovePartFromBandMembers < ActiveRecord::Migration[7.0]
  def change
    remove_column :band_members, :part, :string
  end
end
