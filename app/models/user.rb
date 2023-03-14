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
  has_many :chats, dependent: :destroy

  # Favoriteモデルとのアソシエーション
  has_many :favorites, dependent: :destroy
  has_many :reverse_of_favorites, class_name: "Favorite", foreign_key: "favorited_user_id", dependent: :destroy, inverse_of: :user
  has_many :favoriting_users, through: :favorites, source: :favorited_user
  has_many :favoriting_bands, through: :favorites, source: :band
  has_many :user_favorited_mes, through: :reverse_of_favorites, source: :user

  # Scoutモデルとのアソシエーション
  has_many :scouts, dependent: :destroy
  has_many :reverse_of_scouts, class_name: "Scout", foreign_key: "scouted_user_id", dependent: :destroy, inverse_of: :user
  has_many :scouting_users, through: :scouts, source: :scouted_user
  has_many :scouting_bands, through: :scouts, source: :scouted_band
  has_many :user_scouted_mes, through: :reverse_of_scouts, source: :user
  has_many :band_scouted_mes, through: :reverse_of_scouts, source: :band

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
end
