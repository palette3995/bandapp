class BandGenre < ApplicationRecord
  validates :other_genre, length: { maximum: 15 }

  belongs_to :band
  belongs_to :genre

  def self.ransackable_attributes(_auth_object = nil)
    %w[band_id created_at genre_id id other_genre priority updated_at]
  end
end
