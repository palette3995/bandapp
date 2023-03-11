class ScoutsController < ApplicationController
  before_action :set_user

  def new_user
    @scout = Scout.new
    @scouted_user = User.find(params[:id])
    @parts = Part.where(id: 1..6)
    @bands =Band.where(id: @user.band_members.where(role: "リーダー").pluck(:band_id))
  end

  def new_band
    @scout = Scout.new
    @scouted_band = Band.find(params[:id])
    scouted_band_members = @scouted_band.band_members
    @reader = scouted_band_members.find_by(role: "リーダー").user
    @parts = Part.where(id: 1..6)
    @bands =Band.where(id: @user.band_members.where(role: "リーダー").pluck(:band_id))
  end

  def index
    @scouts = Scout.where(scouted_user_id: @user.id, band_id: nil, scouted_band_id: nil)
  end

  def create
    @scout = Scout.new(scout_params)
    band = Band.find(params[:scout][:band_id]) if params[:scout][:band_id].present?
    scouted_user = User.find(params[:scout][:scouted_user_id])
    if band.present?
      if scouted_user.band_scouted_mes.include?(band)
        flash[:alert] = "既にスカウトを送っています。"
        redirect_to new_user_scout_path(params[:scout][:scouted_user_id])
      elsif band.user_scouted_mes.include?(scouted_user)
        flash[:alert] = "相手から既にスカウトが届いています。"
        redirect_to new_user_scout_path(params[:scout][:scouted_user_id])
      elsif scouted_user.bands.include?(band)
        flash[:alert] = "既にバンドメンバーです。"
        redirect_to new_user_scout_path(params[:scout][:scouted_user_id])
      else
        @scout.save
        flash[:notice] = "スカウトを送りました！"
        redirect_to scouts_path
      end
    else
      @scout.save
      flash[:notice] = "スカウトを送りました！"
      redirect_to scouts_path
    end
  end

  def create_band
    @scout = Scout.new(scout_params)
    band = Band.find(params[:scout][:band_id])
    band_members = band.band_members.map{|member| member.user }
    scouted_band = Band.find(params[:scout][:scouted_band_id])
    scouted_band_members = scouted_band.band_members.map{|member| member.user }
    if band.band_scouted_mes.include?(scouted_band)
      flash[:alert] = "相手バンドから既にスカウトが届いています。"
      redirect_to new_band_scout_path(params[:scout][:scouted_band_id])
    elsif scouted_band.band_scouted_mes.include?(band)
      flash[:alert] ="相手バンドへ既にスカウトを送っています。"
      redirect_to new_band_scout_path(params[:scout][:scouted_band_id])
    elsif (band.user_scouted_mes & scouted_band_members).present?
      flash[:alert] = "相手バンド所属のメンバーから既にスカウトが届いています。"
      redirect_to new_band_scout_path(params[:scout][:scouted_band_id])
    elsif (scouted_band.user_scouted_mes & band_members).present?
      flash[:alert] = "所属メンバーが相手バンドへ既にスカウトを送っています。"
      redirect_to new_band_scout_path(params[:scout][:scouted_band_id])
    elsif (band_members & scouted_band_members).present?
      flash[:alert] = "共通のメンバーがいる為スカウトを送れません。"
      redirect_to new_band_scout_path(params[:scout][:scouted_band_id])
    elsif band_members.count + scouted_band_members.count > 10
      flash[:alert] = "バンドメンバーが10人を超える為スカウトを送れません。"
      redirect_to new_band_scout_path(params[:scout][:scouted_band_id])
    else
      @scout.save
      flash[:notice] = "スカウトを送りました！"
      redirect_to scouts_path
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
    @band.band_members.create(user_id: @scout.user_id, part_id: @scout.part_id, other_part: @scout.other_part, role: "リーダー")
    @band.band_members.create(user_id: @user.id, part_id: @scout.scouted_part_id, other_part: @scout.scouted_other_part, role: "メンバー")
    @scout.destroy
    update_band_colums(@band.id)
    flash[:notice] = "スカウトを承認しました！"
    redirect_to bands_path
  end

  def approve_offer
    @scout = Scout.find(params[:id])
    @band = Band.find(@scout.band_id)
    @band.band_members.create(user_id: @user.id, part_id: @scout.scouted_part_id, other_part: @scout.scouted_other_part, role: "メンバー")
    @scout.destroy
    update_band_colums(@band.id)
    flash[:notice] = "スカウトを承認しました！"
    redirect_to bands_path
  end

  def approve_join
    @scout = Scout.find(params[:id])
    @band = Band.find(@scout.scouted_band_id)
    @band.band_members.create(user_id: @scout.user_id, part_id: @scout.part_id, other_part: @scout.other_part,role: "メンバー")
    @scout.destroy
    update_band_colums(@band.id)
    flash[:notice] = "スカウトを承認しました！"
    redirect_to bands_path
  end

  def approve_marge
    @scout = Scout.find(params[:id])
    offering = Band.find(@scout.band_id)
    offered = Band.find(@scout.scouted_band_id)
    @band = Band.create(name: "新規バンド")
    offering.band_members.each do |member|
      @band.band_members.create(user_id: member.user_id, part_id: member.part_id, role: member.role)
    end
    offered.band_members.each do |member|
      @band.band_members.create(user_id: member.user_id, part_id: member.part_id, role: "メンバー")
    end
    @scout.destroy
    offered.destroy
    offering.destroy
    update_band_colums(@band.id)
    flash[:notice] = "スカウトを承認しました！"
    redirect_to bands_path
  end

  def refuse
    @scout = Scout.find(params[:id])
    @scout.destroy
    flash[:notice] = "スカウトを拒否しました。"
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
