class CreateRecruitMembers < ActiveRecord::Migration[7.0]
  def change
    create_table :recruit_members do |t|
      t.references :band, foreign_key: true
      t.integer :part_id
      t.string :level
      t.string :other_part
      t.string :age
      t.string :sex
      t.timestamps
    end
  end
end
