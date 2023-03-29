class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: %i[show edit update]
  before_action :set_recomend_users, only: %i[index match_ages match_levels match_genres]
  before_action :set_parts, :set_genres, except: %i[show search]
  before_action :set_levels

  def index
    @q = User.ransack(params[:q])
    @user_part = current_user.user_parts.first
    @match_ages = @recomend_users.where(age: current_user.age - 5..current_user.age + 5).limit(4) if current_user.age
    @match_levels = @recomend_users.where(user_parts: { level: @user_part.level }).limit(4)
    @match_genres = @recomend_users.where(user_genres: { genre_id: current_user.genres.pluck(:id) }).limit(4)
  end

  def show
  end

  def edit
    @user_parts = @user.parts
    redirect_to users_path, alert: t("alert.page_unavailable") unless @user == current_user
  end

  def update
    @user_parts = @user.parts
    # メディア削除ボタンが押された際の処理
    if params[:delete_image]
      delete_media(@user.image)
    elsif params[:delete_movie]
      delete_media(@user.movie)
    elsif params[:delete_sound]
      delete_media(@user.sound)
    end
    if @user.update(user_params)
      update_user_bands(@user)
      redirect_to user_path, notice: t("notice.update")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
  end

  def search
    @q = User.ransack(params[:q])
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

  private

  def user_params
    params.require(:user).permit(:name, :prefecture_id, :age, :sex, :favorite, :introduction, :image, :movie,
                                 :sound, :original, :want_to_copy, :motivation, :frequency, :activity_time, :available_day, :compose,
                                 user_parts_attributes: %i[id part_id user_id level other_part _destroy],
                                 user_genres_attributes: %i[id genre_id user_id other_genre _destroy])
  end

  def set_user
    @user = User.find(params[:id])
  end

  def set_parts
    @parts = Part.all
  end

  def set_genres
    @genres = Genre.all
  end

  def set_levels
    @levels = %W[未経験 初心者 中級者 上級者]
  end

  def set_recomend_users
    @recomend_users = User.joins(:user_parts, :user_genres).near(current_user).where.not(id: current_user.id).distinct
  end

  def delete_media(media)
    media.purge
    render action: "edit"
  end

  def update_user_bands(user)
    user.bands.each do |band|
      update_band_colums(band)
    end
  end
end
