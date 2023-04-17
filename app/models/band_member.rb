class BandMember < ApplicationRecord
  validates :other_part, length: { maximum: 15 }

  belongs_to :band
  belongs_to :user
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to_active_hash :part

  def self.ransackable_attributes(_auth_object = nil)
    %w[band_id created_at id other_part part_id role updated_at user_id]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[band part user]
  end
end
