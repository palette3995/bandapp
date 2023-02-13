class BandGenre < ApplicationRecord
  belongs_to :band
  belongs_to :genre
end
