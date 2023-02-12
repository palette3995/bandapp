class Part < ApplicationRecord
  has_many :user_parts, dependent: :destroy
  has_many :users, through: :user_parts
end
