class RemoveColumnFromRecruitMembers < ActiveRecord::Migration[7.0]
  def change
    remove_column :recruit_members, :priority, :integer
  end
end
