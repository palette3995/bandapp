class CreateRecruitMembers < ActiveRecord::Migration[7.0]
  def change
    create_table :recruit_members do |t|
      t.references :band, foreign_key: true
      t.references :part, foreign_key: true
      t.string :level
      t.string :other_part
      t.integer :priority
      t.string :age
      t.string :sex
      t.timestamps
    end
  end
end
