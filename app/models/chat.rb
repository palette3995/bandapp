class Chat < ApplicationRecord
  belongs_to :band
  belongs_to :user
end
