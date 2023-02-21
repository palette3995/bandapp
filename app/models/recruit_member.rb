class RecruitMember < ApplicationRecord
  belongs_to :band
  belongs_to :part
  # Favoriteモデルとのアソシエーション
  has_many :reverse_of_favorites, class_name: "Favorite", dependent: :destroy
  has_many :favorited_mes, through: :reverse_of_favorites, source: :user
end
