class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update]
  before_action :set_current_user, :set_recomend_users, only: %i[index match_ages match_levels]
  before_action :set_user_part, only: %i[index match_levels]
  before_action :set_parts, :set_genres, except: %i[show search]
  before_action :set_user_parts, only: %i[edit update]
  before_action :set_q, only: %i[index search]
  before_action :set_levels

  def index
    @match_ages = @recomend_users.where(age: @current_user.age - 5..@current_user.age + 5).limit(4)
    @match_levels = @recomend_users.where(user_parts: { level: @user_part.level }).limit(4)
  end

  def show
  end

  def edit
  end

  def update
    # メディア削除ボタンが押された際の処理
    if params[:delete_image]
      delete_media(@user.image)
    elsif params[:delete_movie]
      delete_media(@user.movie)
    elsif params[:delete_sound]
      delete_media(@user.sound)
    else
      # 登録完了後の処理
      @user.update(user_params)
      redirect_to user_path
    end
  end

  def search
    @users = @q.result.where.not(id:current_user.id)
  end

  def match_ages
    @users = @recomend_users.where(age: @current_user.age - 5..@current_user.age + 5)
  end

  def match_levels
    @users = @recomend_users.where(user_parts: { level: @user_part.level })
  end

  private

  def user_params
    params.require(:user).permit(
      :name,
      :prefecture_id,
      :age,
      :sex,
      :favorite,
      :introduction,
      :image,
      :movie,
      :sound,
      :original,
      :want_to_copy,
      :motivation,
      :frequency,
      :activity_time,
      :available_day,
      :compose,
      user_parts_attributes: %i[id part_id user_id level other_part _destroy],
      user_genres_attributes: %i[id genre_id user_id other_genre _destroy]
    )
  end

  def set_user
    @user = User.find(params[:id])
  end

  def set_current_user
    @current_user = current_user
  end

  def set_parts
    @parts = Part.all
  end

  def set_user_part
    @user_part = current_user.user_parts.first
  end

  def set_user_parts
    @user_parts = @user.parts
  end

  def set_genres
    @genres = Genre.all
  end

  def set_levels
    @levels = %W[未経験 初心者 中級者 上級者]
  end

  def set_q
    @q = User.ransack(params[:q])
  end

  def set_recomend_users
    @recomend_users = User.joins(:user_parts, :genres).near(current_user).where.not(id:current_user.id).distinct
  end

  def delete_media(media)
    media.purge
    render action: "edit"
  end
end
