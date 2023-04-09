class BandsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_recomend_bands, except: %i[show edit update user_bands search]
  before_action :set_genres, only: %i[index edit update]

  def index
    @parts = Part.all
    @q = Band.ransack(params[:q])
    @match_ages = @recomend_bands.where(average_age: current_user.age - 5..current_user.age + 5).limit(4) if current_user.age
    @match_genres = @recomend_bands.where(band_genres: { genre_id: current_user.genres.pluck(:id) }).limit(4)
    @match_parts = @recomend_bands.where(recruit_members: { part_id: current_user.parts.pluck(:id) }).limit(4)
    @recruiting_beginners = @recomend_bands.where(recruit_members: { level: %W[初心者 未経験] }).limit(4)
    match_originals = @recomend_bands.where(original: current_user.original)
    @match_policies = match_originals.where(motivation: current_user.motivation).or(match_originals.where(frequency: current_user.frequency)).limit(4)
    @match_schedules = if current_user.available_day == "いつでも" || current_user.activity_time == "いつでも"
                         @recomend_bands.limit(4)
                       else
                         @recomend_bands.where(available_day: [current_user.available_day, "いつでも"]).or(@recomend_users.where(activity_time: [current_user.activity_time, "いつでも"])).limit(4)
                       end
  end

  def show
    @band = Band.includes(:users).find(params[:id])
    @members = @band.band_members.includes(user: { image_attachment: :blob })
    @reader = @members.find_by(role: "リーダー").user
    @user = @members.find_by(user_id: current_user.id)
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
    @q = Band.with_attached_image.includes(:band_genres).ransack(params[:q])
    @bands = @q.result.where.not(id: current_user.bands.ids).distinct
  end

  def match_ages
    @bands = @recomend_bands.where(average_age: current_user.age - 5..current_user.age + 5) if current_user.age
  end

  def match_genres
    @bands = @recomend_bands.where(band_genres: { genre_id: current_user.genres.pluck(:id) })
  end

  def match_parts
    @bands = @recomend_bands.where(recruit_members: { part_id: current_user.parts.pluck(:id) })
  end

  def recruiting_beginners
    @bands = @recomend_bands.where(recruit_members: { level: %W[初心者 未経験] })
  end

  def match_policies
    match_originals = @recomend_bands.where(original: current_user.original)
    @bands = match_originals.where(motivation: current_user.motivation).or(match_originals.where(frequency: current_user.frequency))
  end

  def match_schedules
    @bands = if current_user.available_day == "いつでも" || current_user.activity_time == "いつでも"
               @recomend_bands
             else
               @recomend_bands.where(available_day: [current_user.available_day, "いつでも"]).or(@recomend_users.where(activity_time: [current_user.activity_time, "いつでも"]))
             end
  end

  private

  def band_params
    params.require(:band).permit(:name, :prefecture_id, :introduction, :image, :original, :want_to_copy, :motivation, :frequency, :activity_time, :available_day,
                                 band_genres_attributes: %i[id genre_id user_id other_genre _destroy])
  end

  def set_recomend_bands
    @recomend_bands = Band.with_attached_image.includes(:band_genres, :recruit_members).where(prefecture_id: current_user.prefecture_id).where.not(id: current_user.bands.ids).distinct
  end

  def set_genres
    @genres = Genre.all
  end
end
