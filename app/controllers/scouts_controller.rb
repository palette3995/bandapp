class ScoutsController < ApplicationController
  before_action :set_user

  def new_user
    @scout = Scout.new
    @scouted_user = User.find(params[:id])
    @parts = Part.where(id: 1..6)
    bands = @user.bands.joins(:scouts, :band_members).where(band_members: { role: "リーダー" }) # 自分がバンドリーダーでない場合はスカウトを送れない
    @bands = bands.where.not(scouts: { scouted_user_id: @scouted_user.id }) # 同バンドからすでにスカウト送ってる場合を除く
                  .or(bands.where.not(band_members: { user_id: @scouted_user.id })) # 同バンドに相手がすでに所属している場合を除く
                  .or(bands.where.not(scouts: { user_id: @scouted_user.id })) # 同バンドに相手から既にスカウトが来ている場合を
  end

  def new_band
    @scouted_band = Band.find(params[:id])
    @parts = Part.where(id: 1..6)
    @scout = Scout.new(user_id: @user.id, scouted_band_id: @scouted_band.id)
    scouts = Scout.where(scouted_user_id: @scouted_band.id)
    @bands = @user.bands.where.not(id: scouts.pluck(:band_id) << @scouted_band.id)
  end

  def index
    @scouts = Scout.where(scouted_user_id: @user.id, band_id: nil, scouted_band_id: nil)
  end

  def create
    @scout = Scout.new(scout_params)
    if @scout.save
      flash.now[:scout] = "スカウトを送りました。"
      redirect_to scouts_path
    else
      render new_user_scout_path(params[:id])
    end
  end

  def received_offer
    @scouts = Scout.where(scouted_user_id: @user.id, scouted_band_id: nil).where.not(band_id: nil)
  end

  def received_join
    @scouts = Scout.where(scouted_user_id: @user.id, band_id: nil).where.not(scouted_band_id: nil)
  end

  def received_marge
    @scouts = Scout.where(scouted_user_id: @user.id).where.not(band_id: nil).where.not(scouted_band_id: nil)
  end

  def send_new
    @scouts = @user.scouts.where(band_id: nil, scouted_band_id: nil)
  end

  def send_offer
    @scouts = @user.scouts.where(scouted_band_id: nil).where.not(band_id: nil)
  end

  def send_join
    @scouts = @user.scouts.where(band_id: nil).where.not(scouted_band_id: nil)
  end

  def send_marge
    @scouts = @user.scouts.where.not(band_id: nil).where.not(scouted_band_id: nil)
  end

  def approve_new
    @scout = Scout.find(params[:id])
    @band = Band.create(name: "新規バンド")
    BandMember.create(band_id: @band.id, user_id: @scout.user_id, part_id: @scout.part_id,
                      other_part: @scout.other_part, role: "リーダー")
    BandMember.create(band_id: @band.id, user_id: @user.id, part_id: @scout.scouted_part_id,
                      other_part: @scout.scouted_other_part, role: "メンバー")
    @scout.destroy
    redirect_to bands_path
  end

  def approve_offer
    @scout = Scout.find(params[:id])
    @band = Band.find(@scout.band_id)
    BandMember.create(band_id: @band.id, user_id: @user.id, part_id: @scout.scouted_part_id,
                      other_part: @scout.scouted_other_part, role: "メンバー")
    @scout.destroy
    redirect_to bands_path
  end

  def approve_join
    @scout = Scout.find(params[:id])
    @band = Band.find(@scout.scouted_band_id)
    BandMember.create(band_id: @band.id, user_id: @scout.user_id, part: @scout.part_id, other_part: @scout.other_part,
                      role: "メンバー")
    @scout.destroy
    redirect_to bands_path
  end

  def approve_marge
    @scout = Scout.find(params[:id])
    offering = Band.find(@scout.band_id)
    offered = Band.find(@scout.scouted_band_id)
    @band = Band.create(name: "新規バンド")
    offering.band_members.each do |member|
      member.band_id = @band.id
      member.save
    end
    offered.band_members.each do |member|
      member.band_id = @band.id
      member.role = "メンバー"
      member.save
    end
    offering.destroy
    offered.destroy
    @scout.destroy
    redirect_to bands_path
  end

  def refuse
    @scout = Scout.find(params[:id])
    @scout.destroy
    redirect_to scouts_path
  end

  private

  def scout_params
    params.require(:scout).permit(:user_id, :scouted_user_id, :band_id, :scouted_band_id, :part_id, :scouted_part_id,
                                  :other_part, :scouted_other_part, :message)
  end

  def set_user
    @user = current_user
  end
end
