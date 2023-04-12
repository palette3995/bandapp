class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  protect_from_forgery with: :exception

  def after_sign_in_path_for(_resource)
    users_path
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name])
  end

  def update_band_colums(band)
    band.update!(
      number_of_member: band.band_members.count,
      maximum_age: band.band_members.joins(:user).maximum(:age),
      minimum_age: band.band_members.joins(:user).minimum(:age),
      average_age: band.band_members.joins(:user).average(:age),
      men: band.band_members.joins(:user).where(user: { sex: "男性" }).count,
      women: band.band_members.joins(:user).where(user: { sex: "女性" }).count
    )
  end
end
