class FavoritesController < ApplicationController
  before_action :set_user

  def index
    @users = @user.favoriting_users
  end

  def send_band
    @bands = @user.favoriting_bands
  end

  def received_user
    @users = @user.user_favorited_mes
  end

  def received_band
    @favorites = Favorite.where(band_id: @user.bands.ids)
  end

  def create_user
    @favorited_user = User.find(params[:id])
    @user.favorites.find_or_create_by(favorited_user_id: params[:id])

    render turbo_stream: turbo_stream.replace(
      'favorite-user-button',
      partial: 'shared/favorite_user',
      locals: { user: @favorited_user },
    )
  end

  def create_band
    @favorited_band = Band.find(params[:id])
    @user.favorites.find_or_create_by(band_id: params[:id])

    render turbo_stream: turbo_stream.replace(
      'favorite-band-button',
      partial: 'shared/favorite_band',
      locals: { band: @favorited_band },
    )
  end

  def destroy
    @favorited_user = User.find(params[:id])
    @favorite = @user.favorites.find_by(favorited_user_id: params[:id])
    @favorite.destroy if @favorite

    render turbo_stream: turbo_stream.replace(
      'favorite-user-button',
      partial: 'shared/favorite_user',
      locals: { user: @favorited_user },
    )
  end

  def destroy_band
    @favorited_band = Band.find(params[:id])
    @favorite = @user.favorites.find_by(band_id: params[:id])
    @favorite.destroy if @favorite

    render turbo_stream: turbo_stream.replace(
      'favorite-band-button',
      partial: 'shared/favorite_band',
      locals: { band: @favorited_band },
    )
  end

  private

  def set_user
    @user = current_user
  end
end
