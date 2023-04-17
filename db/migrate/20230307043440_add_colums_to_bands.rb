class AddColumsToBands < ActiveRecord::Migration[7.0]
  def change
    add_column :bands, :maximum_age, :integer
    add_column :bands, :minimum_age, :integer
    add_column :bands, :average_age, :integer
    add_column :bands, :number_of_member, :integer
    add_column :bands, :men, :integer
    add_column :bands, :women, :integer
  end
end
