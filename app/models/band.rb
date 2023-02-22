class Band < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to_active_hash :prefecture

  has_many :band_members, dependent: :destroy
  has_many :users, through: :band_members
  has_many :recruit_members, dependent: :destroy
  has_many :parts, through: :recruit_members
  has_many :band_genres, dependent: :destroy
  has_many :genres, through: :band_genres
  # Favoriteモデルとのアソシエーション
  has_many :favorites, dependent: :destroy
  has_many :reverse_of_favorites, class_name: "Favorite", dependent: :destroy
  has_many :favoriting_users, through: :favorites, source: :favorited_user
  has_many :favoriting_bands, through: :favorites, source: :favorited_band
  has_many :user_favorited_mes, through: :reverse_of_favorites, source: :user
  has_many :band_favorited_mes, through: :reverse_of_favorites, source: :band

  accepts_nested_attributes_for :band_genres, allow_destroy: true

  has_one_attached :image
end
