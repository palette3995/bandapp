class UserPart < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :part

  enum :level, %W[未経験 初心者 中級者 上級者]

  def self.ransackable_attributes(auth_object = nil)
    ["level", "other_part", "part_id", "priority"]
  end
end
