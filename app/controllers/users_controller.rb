class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_recomend_users, except: %i[show edit update search]
  before_action :set_parts, :set_genres, except: %i[show search]

  def index
    @q = User.ransack(params[:q])
    @user_part = current_user.user_parts.first
    @match_ages = @recomend_users.where(age: current_user.age - 5..current_user.age + 5).limit(4) if current_user.age
    @match_levels = @recomend_users.where(user_parts: { level: @user_part.level }).limit(4)
    @match_genres = @recomend_users.where(user_genres: { genre_id: current_user.genres.pluck(:id) }).limit(4)
    match_originals = @recomend_users.where(original: current_user.original)
    @match_policies = match_originals.where(motivation: current_user.motivation).or(match_originals.where(frequency: current_user.frequency)).limit(4)
    @match_schedules = if current_user.available_day == "いつでも" || current_user.activity_time == "いつでも"
                         @recomend_users.limit(4)
                       else
                         @recomend_users.where(available_day: [current_user.available_day, "いつでも"]).or(@recomend_users.where(activity_time: [current_user.activity_time, "いつでも"])).limit(4)
                       end
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
    @user_parts = @user.parts
    redirect_to users_path, alert: t("alert.page_unavailable") unless @user == current_user
  end

  def update
    @user = User.find(params[:id])
    @user_parts = @user.parts
    @user.image.purge if params[:delete_image]
    @user.movie.purge if params[:delete_movie]
    @user.sound.purge if params[:delete_sound]
    if @user.update(user_params)
      @user.bands.each do |band|
        update_band_colums(band)
      end
      redirect_to user_path, notice: t("notice.update")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def search
    @q = User.with_attached_image.includes(:user_parts).ransack(params[:q])
    @users = @q.result.where.not(id: current_user.id).distinct
  end

  def match_ages
    @users = @recomend_users.where(age: current_user.age - 5..current_user.age + 5) if current_user.age
  end

  def match_levels
    @user_part = current_user.user_parts.first
    @users = @recomend_users.where(user_parts: { level: @user_part.level })
  end

  def match_genres
    @users = @recomend_users.where(user_genres: { genre_id: current_user.genres.pluck(:id) })
  end

  def match_policies
    match_originals = @recomend_users.where(original: current_user.original)
    @users = match_originals.where(motivation: current_user.motivation).or(match_originals.where(frequency: current_user.frequency))
  end

  def match_schedules
    @users = if current_user.available_day == "いつでも" || current_user.activity_time == "いつでも"
               @recomend_users
             else
               @recomend_users.where(available_day: [current_user.available_day, "いつでも"]).or(@recomend_users.where(activity_time: [current_user.activity_time, "いつでも"]))
             end
  end

  private

  def user_params
    params.require(:user).permit(:name, :prefecture_id, :age, :sex, :favorite, :introduction, :image, :movie,
                                 :sound, :original, :want_to_copy, :motivation, :frequency, :activity_time, :available_day, :compose,
                                 user_parts_attributes: %i[id part_id user_id level other_part _destroy],
                                 user_genres_attributes: %i[id genre_id user_id other_genre _destroy])
  end

  def set_parts
    @parts = Part.all
  end

  def set_genres
    @genres = Genre.all
  end

  def set_recomend_users
    @recomend_users = User.with_attached_image.includes(:user_parts, :user_genres).near(current_user).where.not(id: current_user.id).distinct
  end
end
