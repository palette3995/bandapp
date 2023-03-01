class Part < ApplicationRecord
  has_many :user_parts, dependent: :destroy
  has_many :users, through: :user_parts
  has_many :recruit_members, dependent: :destroy
  has_many :bands, through: :recruit_members
  has_many :scouts, dependent: :destroy
  has_many :band_members, dependent: :destroy
end
