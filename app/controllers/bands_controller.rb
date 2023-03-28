class BandsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_q, only: %i[index search]
  before_action :set_levels, only: %i[index]
  before_action :set_recomend_bands, only: %i[index match_ages match_genres]

  def index
    @parts = Part.all
    @genres = Genre.all
    @match_ages = @recomend_bands.where(average_age: current_user.age - 5..current_user.age + 5).limit(4) if current_user.age
    @match_genres = @recomend_bands.where(band_genres: { genre_id: current_user.genres.pluck(:id) }).limit(4)
  end

  def show
    @band = Band.find(params[:id])
    @members = @band.band_members
    @recruits = @band.recruit_members
    @reader = @members.find_by(role: "リーダー").user
    @user = @members.find_by(user_id: current_user.id)
  end

  def edit
    @band = Band.find(params[:id])
    redirect_to user_bands_bands_path, alert: t("alert.page_unavailable") unless @band.users.include?(current_user)
    @genres = Genre.all
  end

  def update
    @band = Band.find(params[:id])
    @genres = Genre.all
    # メディア削除ボタンが押された際の処理
    delete_media(@band.image) if params[:delete_image]
    if @band.update(band_params)
      redirect_to band_path, notice: t("notice.update")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
  end

  def user_bands
    @bands = current_user.bands
  end

  def search
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

  def set_q
    @q = Band.ransack(params[:q])
  end

  def set_levels
    @levels = %W[未経験 初心者 中級者 上級者]
  end

  def set_recomend_bands
    @recomend_bands = Band.joins(:band_genres).where(prefecture_id: current_user.prefecture_id).where.not(id: current_user.bands.ids).distinct
  end

  def delete_media(media)
    media.purge
    render action: "edit"
  end
end
