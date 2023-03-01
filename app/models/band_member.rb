class BandMember < ApplicationRecord
  belongs_to :band
  belongs_to :user
  belongs_to :part
end
