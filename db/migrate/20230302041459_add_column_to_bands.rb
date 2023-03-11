class AddColumnToBands < ActiveRecord::Migration[7.0]
  def change
    add_column :bands, :frequency, :string
  end
end
