class Scout < ApplicationRecord
  belongs_to :user
  belongs_to :scouted_user, class_name: "User", optional: true
  belongs_to :band, optional: true
  belongs_to :scouted_band, class_name: "Band", optional: true
  belongs_to :part, optional: true
  belongs_to :scouted_part, class_name: "Part", optional: true
end
