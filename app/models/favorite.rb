class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :favorited_user, class_name: "User"
  belongs_to :band
  belongs_to :favorited_band, class_name: "Band"
  belongs_to :recruit_member
end
