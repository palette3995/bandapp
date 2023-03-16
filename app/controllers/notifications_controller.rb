class NotificationsController < ApplicationController
  def index
    @notifications = current_user.notifications.order(created_at: :desc).page(params[:page])
  end

  def unreads
    @notifications = current_user.notifications.where(read: false).order(created_at: :desc).page(params[:page])
  end

  def read
    notification = current_user.notifications.find(params[:id])
    notification.update(read: true) unless notification.read?
    redirect_to notification.subject.redirect_path
  end

  def read_all
    notifications = current_user.notifications.where(read: false)
    notifications.each do |notification|
      notification.update(read: true)
    end
    redirect_to notifications_path
  end
end
