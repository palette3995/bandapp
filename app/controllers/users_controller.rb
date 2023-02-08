class UsersController < ApplicationController
  before_action :week_days
  before_action :activity_times
  before_action :levels
  def index
    @user = User.find(current_user.id)
    UserPart.setup(@user) if @user.user_parts.blank?
  end

  def show
  end

  def mypage
    @user = User.find(current_user.id)
  end

  def edit
    @user = User.find(params[:id])
    @parts = Part.all
    @user_parts = @user.parts
  end

  def update
    @user = User.find(params[:id])
    @parts = Part.all
    @user_parts = @user.parts
    # メディア削除ボタンが押された際の処理
    if params[:delete_image]
      delete_media(@user.image)
    elsif params[:delete_movie]
      delete_media(@user.movie)
    elsif params[:delete_sound]
      delete_media(@user.sound)
    else
      # 登録完了後の処理
      params[:user][:available_day] ? @user.available_day = params[:user][:available_day].join(",") : false
      params[:user][:activity_time] ? @user.activity_time = params[:user][:activity_time].join(",") : false
      @user.update(user_params)
      redirect_to mypage_path
    end
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

  def levels
    @levels = %W[未経験 初心者 中級者 上級者]
  end

  def delete_media(media)
    media.purge
    render action: "edit"
  end
end
