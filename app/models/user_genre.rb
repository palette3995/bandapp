class UserGenre < ApplicationRecord
  validates :other_genre, length: { maximum: 15 }

  belongs_to :user, optional: true
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to_active_hash :genre

  def self.ransackable_attributes(_auth_object = nil)
    %w[genre_id other_genre priority]
  end
end
