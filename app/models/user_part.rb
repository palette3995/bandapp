class UserPart < ApplicationRecord
  belongs_to :user
  belongs_to :part

  def self.setup(user)
    3.times do |n|
      user.user_parts.create(user_id: user.id, part_id: 7, priority: n + 1)
    end

  end
end
