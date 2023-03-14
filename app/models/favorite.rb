class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :favorited_user, class_name: "User", optional: true
  belongs_to :band, optional: true
  has_one :notification, as: :subject, dependent: :destroy
end
