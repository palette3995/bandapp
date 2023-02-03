class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  protect_from_forgery with: :exception

  def after_sign_in_path_for(resource)
    users_path(resource)
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name])
  end

  def week_days
    @week_days = %W[日 月 火 水 木 金 土]
  end

  def activity_times
    @activity_times = %W[朝 昼 夜]
  end
end
