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
    @favorites = @user.bands.joins(:favorites).where(favorites: {band_id: @user.bands.ids})
  end

  def create_user
    @favorited_user = User.find(params[:id])
    @user.favorites.find_or_create_by(favorited_user_id: @favorite_user.id)
  end

  def create_band
    @favorited_band = Band.find(params[:id])
    @user.favorites.find_or_create_by(band_id: @favorite_band.id)
  end

  def destroy
    @favorite = @user.favorites.find_by(favorited_user_id: params[:id])
    @favorite.destroy if @favorite
  end

  def destroy_band
    @favorite = @user.favorites.find_by(band_id: params[:id])
    @favorite.destroy if @favorite
  end

  private

  def set_user
    @user = current_user
  end
end
