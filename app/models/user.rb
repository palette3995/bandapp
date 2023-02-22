class User < ApplicationRecord
  scope :near, ->(user) { where(prefecture_id: user.prefecture_id).order(current_sign_in_at: :desc) }
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to_active_hash :prefecture
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :trackable

  has_many :user_parts, dependent: :destroy
  has_many :parts, through: :user_parts
  has_many :user_genres, dependent: :destroy
  has_many :genres, through: :user_genres
  has_many :band_members, dependent: :destroy
  has_many :bands, through: :band_members

  # Favoriteモデルとのアソシエーション
  has_many :favorites, dependent: :destroy
  has_many :reverse_of_favorites, class_name: "Favorite", dependent: :destroy
  has_many :favoriting_users, through: :favorites, source: :favorited_user
  has_many :favoriting_bands, through: :favorites, source: :favorited_band
  has_many :user_favorited_mes, through: :reverse_of_favorites, source: :user
  has_many :band_favorited_mes, through: :reverse_of_favorites, source: :band
  has_many :recruit_members, through: :favorites

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

  # 検索機能関連のメソッド
  def self.ransackable_attributes(_auth_object = nil)
    %w[activity_time age available_day compose created_at favorite frequency id image
       introduction motivation movie name original prefecture_id remember_created_at sex sound updated_at want_to_copy]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[band_members bands genres parts prefecture user_genres user_parts]
  end

  # いいね機能関連のメソッド
  def favorite_user(receiver, band)
    if band?
      favorite = Favorite.find_by(favorited_user_id: receiver.id, band_id: band.id)
      favorites.create(favorited_user_id: receiver.id, band_id: band.id) unless favorite
    else
      favorites.find_or_create_by(favorited_user_id: receiver.id) unless self == receiver
    end
  end

  def favorite_band(receiver, band)
    if band?
      favorite = Favorite.find_by(favorited_band_id: receiver.id, band_id: band.id)
      favorites.create(favorited_band_id: receiver.id, band_id: band.id) unless favorite
    else
      favorites.find_or_create_by(favorited_band_id: receiver.id) unless bands.pluck(:id).include?(receiver.id)
    end
  end

  def favorite_recruit(receiver)
    favorites.find_or_create_by(recruit_member_id: receiver.id) unless bands.pluck(:id).include?(receiver.band_id)
  end

  def cancel_favorite_user(receiver, _band)
    favorite = if band?
                 favorites.find_by(favorited_user_id: receiver.id, band_id: :band.id)
               else
                 favorites.find_by(favorited_user_id: receiver.id)
               end
    favorite&.destroy
  end

  def cancel_favorite_band(receiver, _band)
    favorite = if band?
                 favorites.find_by(favorited_band_id: receiver.id, band_id: :band.id)
               else
                 favorites.find_by(favorited_band_id: receiver.id)
               end
    favorite&.destroy
  end

  def cancel_favorite_recruit(receiver)
    favorite = favorites.find_by(recruit_member_id: receiver.id)
    favorite&.destroy
  end
end
