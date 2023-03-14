class Notification < ApplicationRecord
  belongs_to :subject, polymorphic: true
end
