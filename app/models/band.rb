class Band < ApplicationRecord
  after_create :create_genres
  validates :name, length: { maximum: 30 }, presence: true
  validates :want_to_copy, length: { maximum: 50 }
  validates :introduction, length: { maximum: 500 }

  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to_active_hash :prefecture

  has_many :band_members, dependent: :destroy
  has_many :users, through: :band_members
  has_many :recruit_members, dependent: :destroy
  has_many :band_genres, dependent: :destroy
  has_many :chats, dependent: :destroy

  # Favoriteモデルとのアソシエーション
  has_many :favorites, dependent: :destroy
  has_many :user_favorited_mes, through: :favorites, source: :user

  # Scoutモデルとのアソシエーション
  has_many :scouts, dependent: :destroy
  has_many :reverse_of_scouts, class_name: "Scout", foreign_key: "scouted_band_id", dependent: :destroy, inverse_of: :band
  has_many :scouting_users, through: :scouts, source: :scouted_user
  has_many :scouting_bands, through: :scouts, source: :scouted_band
  has_many :user_scouted_mes, through: :reverse_of_scouts, source: :user
  has_many :band_scouted_mes, through: :reverse_of_scouts, source: :band

  accepts_nested_attributes_for :band_genres, allow_destroy: true

  has_one_attached :image

  def self.ransackable_attributes(_auth_object = nil)
    %w[activity_time available_day created_at frequency id image introduction motivation name
       original prefecture_id updated_at want_to_copy number_of_member maximum_age minimum_age average_age men women ]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[band_favorited_mes band_genres band_members band_scouted_mes favorites favoriting_bands
       favoriting_users genres image_attachment image_blob parts prefecture recruit_members reverse_of_favorites reverse_of_scouts scouting_bands scouting_users scouts user_favorited_mes user_scouted_mes users]
  end

  def genres
    band_genres.map(&:genre)
  end

  def already_scouted?(band)
    band_scouted_mes.include?(band)
  end

  def already_scouted_from_member?(band)
    reverse_of_scouts.where(user_id: band.band_members.map(&:user_id), band_id: nil).present?
  end

  private

  def create_genres
    3.times do |n|
      band_genres.create(band_id: id, genre_id: 16, priority: n + 1)
    end
  end
end
