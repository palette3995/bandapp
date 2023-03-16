class Favorite < ApplicationRecord
  after_create_commit :create_notifications
  belongs_to :user
  belongs_to :favorited_user, class_name: "User", optional: true
  belongs_to :band, optional: true
  has_one :notification, as: :subject, dependent: :destroy

  delegate :name, to: :user

  def redirect_path
    "/favorites"
  end

  private

  def create_notifications
    if favorited_user_id.present?
      Notification.create!(subject: self, user_id: favorited_user_id, notification_type: Notification.notification_types[:favorite_you])
    else
      band = Band.find(band_id)
      band.band_members.each do |member|
        Notification.create!(subject: self, user_id: member.user_id, notification_type: Notification.notification_types[:favorite_your_band])
      end
    end
  end
end
