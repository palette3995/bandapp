class BandsController < ApplicationController
  def index
    @user = current_user
    @bands = @user.bands
  end

  def show
    @band = Band.find(params[:id])
    @members = @band.band_members
    @recruits = @band.recruit_members
    @reader = @members.find_by(role: "リーダー").user
    @delete_id = @members.find_by(user_id: current_user.id).id
  end

  def edit
    @band = Band.find(params[:id])
    @genres = Genre.all
  end

  def update
    @band = Band.find(params[:id])
    # メディア削除ボタンが押された際の処理
    if params[:delete_image]
      delete_media(@band.image)
    else
      # 登録完了後の処理
      @band.update(user_params)
      redirect_to band_path
    end
  end

  def destroy
  end

  private

  def band_params
    params.require(:band).permit(
      :name,
      :prefecture_id,
      :introduction,
      :image,
      :original,
      :want_to_copy,
      :motivation,
      :frequency,
      :activity_time,
      :available_day,
      band_genres_attributes: %i[id genre_id user_id other_genre _destroy]
    )
  end

  def delete_media(media)
    media.purge
    render action: "edit"
  end
end
