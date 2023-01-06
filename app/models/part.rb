class Part < ApplicationRecord
  has_many :user_parts
  has_many :users, through: :user_parts
end
