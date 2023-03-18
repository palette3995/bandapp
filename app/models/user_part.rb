class UserPart < ApplicationRecord
  validates :other_part, length: { maximum: 15 }

  belongs_to :user, optional: true
  belongs_to :part

  enum :level, %W[未経験 初心者 中級者 上級者]

  def self.ransackable_attributes(_auth_object = nil)
    %w[level other_part part_id priority]
  end
end
