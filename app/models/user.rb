class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :user_parts, dependent: :destroy
  has_many :parts, through: :user_parts

  accepts_nested_attributes_for :user_parts, allow_destroy: true

  has_one_attached :image
  has_one_attached :movie
  has_one_attached :sound
end
