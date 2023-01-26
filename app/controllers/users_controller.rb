class UsersController < ApplicationController
  before_action :get_week_day
  before_action :get_activity_time
  before_action :get_level
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
    params[:user][:available_day] ? @user.available_day = params[:user][:available_day].join(",") : false
    params[:user][:activity_time] ? @user.activity_time = params[:user][:activity_time].join(",") : false
    @user.update(user_params)
    redirect_to mypage_path
  end

  private

  def user_params
    params.require(:user).permit(
      :name,
      :prefecture_id,
      :age,
      :sex,
      :genre,
      :favorite,
      :introduction,
      :image,
      :movie,
      :sound,
      :original,
      :want_to_copy,
      :motivation,
      :other_part,
      :frequency,
      :activity_time,
      :available_day,
      :compose,
      user_parts_attributes: %i[id part_id user_id level _destroy]
    )
  end

  def get_level
    @levels = ["未経験","初心者","中級者","上級者"]
  end

  def delete_media(media)
    media.purge
  end

end
