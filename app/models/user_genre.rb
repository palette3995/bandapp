class UserGenre < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :genre

  def self.ransackable_attributes(auth_object = nil)
    ["genre_id", "other_genre", "priority",]
  end
end
