class Genre < ApplicationRecord
  has_many :user_genres, dependent: :destroy
  has_many :users, through: :user_genres
  has_many :band_genres, dependent: :destroy
  has_many :bands, through: :band_genres
end
