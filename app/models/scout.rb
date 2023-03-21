class Scout < ApplicationRecord
  after_create_commit :create_notifications
  validates :other_part, length: { maximum: 15 }
  validates :scouted_other_part, length: { maximum: 15 }
  validates :message, length: { maximum: 30 }

  belongs_to :user
  belongs_to :scouted_user, class_name: "User", optional: true
  belongs_to :band, optional: true
  belongs_to :scouted_band, class_name: "Band", optional: true
  belongs_to :part, optional: true
  belongs_to :scouted_part, class_name: "Part", optional: true
  has_one :notification, as: :subject, dependent: :destroy

  def name
    (user.name.presence || band.name)
  end

  def redirect_path
    "/scouts"
  end

  private

  def create_notifications
    if band_id.nil? && scouted_band_id.nil?
      Notification.create!(subject: self, user_id: scouted_user_id, notification_type: Notification.notification_types[:new_band_scout])
    elsif band_id.present? && scouted_band_id.nil?
      Notification.create!(subject: self, user_id: scouted_user_id, notification_type: Notification.notification_types[:band_scout_you])
    elsif band_id.nil? && scouted_band_id.present?
      scouted_band.band_members.each do |member|
        Notification.create!(subject: self, user_id: member.user_id, notification_type: Notification.notification_types[:want_to_join_your_band])
      end
    elsif band_id.present? && scouted_band_id.present?
      scouted_band.band_members.each do |member|
        Notification.create!(subject: self, user_id: member.user_id, notification_type: Notification.notification_types[:marge_band_request])
      end
    end
  end
end
