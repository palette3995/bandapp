class AddPartIdToBandMembers < ActiveRecord::Migration[7.0]
  def change
    add_reference :band_members, :part, foreign_key: true
  end
end
