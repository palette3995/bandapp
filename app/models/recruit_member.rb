class RecruitMember < ApplicationRecord
  belongs_to :band
  belongs_to :part
  # Favoriteモデルとのアソシエーション
  has_many :reverse_of_favorites, class_name: "Favorite", dependent: :destroy
  has_many :favorited_mes, through: :reverse_of_favorites, source: :user

  def self.ransackable_attributes(_auth_object = nil)
    %w[age band_id created_at id level other_part part_id sex updated_at]
  end
end
