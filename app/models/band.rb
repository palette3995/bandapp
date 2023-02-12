class Band < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to_active_hash :prefecture

  has_many :band_members, dependent: :destroy
  has_many :users, through: :band_members
  has_many :recruit_members, dependent: :destroy
  has_many :parts, through: :recruit_members
  has_many :band_genres, dependent: :destroy
  has_many :genres, through: :band_genres

  accepts_nested_attributes_for :band_genres, allow_destroy: true

  has_one_attached :image
end
