class UserGenre < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :genre

  def self.ransackable_attributes(_auth_object = nil)
    %w[genre_id other_genre priority]
  end
end
