class Notification < ApplicationRecord
  belongs_to :subject, polymorphic: true

  enum notification_type: {
    favorite_you: 0,
    favorite_your_band: 1,
    new_band_scout: 2,
    band_scout_you: 3,
    want_to_join_your_band: 4,
    marge_band_request: 5
  }
end
