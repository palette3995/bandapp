class Chat < ApplicationRecord
  validates :message, length: { maximum: 500 }, presence: true

  belongs_to :band
  belongs_to :user
end
