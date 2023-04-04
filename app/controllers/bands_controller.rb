class BandsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_recomend_bands, only: %i[index match_ages match_genres]
  before_action :set_genres, only: %i[index edit update]

  def index
    @parts = Part.all
    @q = Band.ransack(params[:q])
    @match_ages = @recomend_bands.where(average_age: current_user.age - 5..current_user.age + 5).limit(4) if current_user.age
    @match_genres = @recomend_bands.where(band_genres: { genre_id: current_user.genres.pluck(:id) }).limit(4)
  end

  def show
    @band = Band.find(params[:id])
    @reader = @band.band_members.find_by(role: "リーダー").user
    @user = @band.band_members.find_by(user_id: current_user.id)
  end

  def edit
    @band = Band.find(params[:id])
    redirect_to user_bands_bands_path, alert: t("alert.page_unavailable") unless @band.users.include?(current_user)
  end

  def update
    @band = Band.find(params[:id])
    @band.image.purge if params[:delete_image]
    if @band.update(band_params)
      redirect_to band_path, notice: t("notice.update")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def user_bands
    @bands = current_user.bands
  end

  def search
    @q = Band.ransack(params[:q])
    @bands = @q.result.where.not(id: current_user.bands.ids).distinct
  end

  def match_ages
    @bands = @recomend_bands.where(average_age: current_user.age - 5..current_user.age + 5) if current_user.age
  end

  def match_genres
    @bands = @recomend_bands.where(band_genres: { genre_id: current_user.genres.pluck(:id) })
  end

  private

  def band_params
    params.require(:band).permit(:name, :prefecture_id, :introduction, :image, :original, :want_to_copy, :motivation, :frequency, :activity_time, :available_day,
                                 band_genres_attributes: %i[id genre_id user_id other_genre _destroy])
  end

  def set_recomend_bands
    @recomend_bands = Band.joins(:band_genres).where(prefecture_id: current_user.prefecture_id).where.not(id: current_user.bands.ids).distinct
  end

  def set_genres
    @genres = Genre.all
  end
end
