class RecruitMember < ApplicationRecord
  validates :other_part, length: { maximum: 15 }

  belongs_to :band

  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to_active_hash :part

  def self.ransackable_attributes(_auth_object = nil)
    %w[age band_id created_at id level other_part part_id sex updated_at]
  end
end
