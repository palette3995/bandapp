class AddColumnToScouts < ActiveRecord::Migration[7.0]
  def change
    add_column :scouts, :message, :string
  end
end
