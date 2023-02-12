class User < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to_active_hash :prefecture
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :user_parts, dependent: :destroy
  has_many :parts, through: :user_parts
  has_many :user_genres, dependent: :destroy
  has_many :genres, through: :user_genres
  has_many :band_members, dependent: :destroy
  has_many :bands, through: :band_members

  accepts_nested_attributes_for :user_parts, allow_destroy: true
  accepts_nested_attributes_for :user_genres, allow_destroy: true

  has_one_attached :image
  has_one_attached :movie
  has_one_attached :sound

  after_create do
    3.times do |n|
      user_parts.create(user_id: id, part_id: 7, priority: n + 1)
      user_genres.create(user_id: id, genre_id: 16, priority: n + 1)
    end
  end
end
