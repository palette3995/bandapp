class AddOtherPartBandMembers < ActiveRecord::Migration[7.0]
  def change
    add_column :band_members, :other_part, :string
  end
end
