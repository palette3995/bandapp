class FavoritesController < ApplicationController
  before_action :authenticate_user!

  def index
    @users = current_user.favoriting_users.page(params[:page])
  end

  def send_band
    @bands = current_user.favoriting_bands.page(params[:page])
  end

  def received_user
    @users = current_user.user_favorited_mes.page(params[:page])
  end

  def received_band
    @favorites = Favorite.where(band_id: current_user.bands.ids).page(params[:page])
  end

  def create_user
    @favorited_user = User.find(params[:id])
    current_user.favorites.find_or_create_by(favorited_user_id: params[:id])

    render turbo_stream: turbo_stream.replace(
      "favorite-user-button",
      partial: "shared/favorite_user",
      locals: { user: @favorited_user }
    )
  end

  def create_band
    @favorited_band = Band.find(params[:id])
    current_user.favorites.find_or_create_by(band_id: params[:id])

    render turbo_stream: turbo_stream.replace(
      "favorite-band-button",
      partial: "shared/favorite_band",
      locals: { band: @favorited_band }
    )
  end

  def destroy
    @favorited_user = User.find(params[:id])
    @favorite = current_user.favorites.find_by(favorited_user_id: params[:id])
    @favorite&.destroy

    render turbo_stream: turbo_stream.replace(
      "favorite-user-button",
      partial: "shared/favorite_user",
      locals: { user: @favorited_user }
    )
  end

  def destroy_band
    @favorited_band = Band.find(params[:id])
    @favorite = current_user.favorites.find_by(band_id: params[:id])
    @favorite&.destroy

    render turbo_stream: turbo_stream.replace(
      "favorite-band-button",
      partial: "shared/favorite_band",
      locals: { band: @favorited_band }
    )
  end
end
