class ScoutsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user
  before_action :set_parts, :set_bands, only: %i[new_user new_band create create_band]

  def new_user
    @scout = Scout.new
    @scouted_user = User.find(params[:id])
  end

  def new_band
    @scout = Scout.new
    @scouted_band = Band.find(params[:id])
    scouted_band_members = @scouted_band.band_members
    @reader = scouted_band_members.find_by(role: "リーダー").user
  end

  def index
    @scouts =  @user.reverse_of_scouts.where(band_id: nil, scouted_band_id: nil).page(params[:page])
  end

  def create
    @scout = Scout.new(scout_params)
    band = Band.find(params[:scout][:band_id]) if params[:scout][:band_id].present?
    @scouted_user = User.find(params[:scout][:scouted_user_id])
    if band.present?
      if @scouted_user.band_scouted_mes.include?(band)
        flash[:alert] = t("alert.sent")
        redirect_to new_user_scout_path(params[:scout][:scouted_user_id]) and return
      elsif band.user_scouted_mes.include?(@scouted_user)
        flash[:alert] = t("alert.received")
        redirect_to new_user_scout_path(params[:scout][:scouted_user_id]) and return
      elsif @scouted_user.bands.include?(band)
        flash[:alert] = t("alert.registered")
        redirect_to new_user_scout_path(params[:scout][:scouted_user_id]) and return
      end
    end
    if @scout.save
      redirect_to scouts_path, notice: t("notice.scout")
    else
      render :new_user, status: :unprocessable_entity
    end
  end

  def create_band
    @scout = Scout.new(scout_params)
    @scouted_band = Band.find(params[:scout][:scouted_band_id])
    scouted_band_members = @scouted_band.band_members.map(&:user)
    @reader = @scouted_band.band_members.find_by(role: "リーダー").user
    if params[:scout][:band_id]
      band = Band.find(params[:scout][:band_id])
      band_members = band.band_members.map(&:user)
      if band.band_scouted_mes.include?(@scouted_band)
        flash[:alert] = t("alert.received")
        redirect_to new_band_scout_path(params[:scout][:scouted_band_id]) and return
      elsif @scouted_band.band_scouted_mes.include?(band)
        flash[:alert] = t("alert.sent")
        redirect_to new_band_scout_path(params[:scout][:scouted_band_id]) and return
      elsif (band.user_scouted_mes & scouted_band_members).present?
        flash[:alert] = t("alert.received_other")
        redirect_to new_band_scout_path(params[:scout][:scouted_band_id]) and return
      elsif (@scouted_band.user_scouted_mes & band_members).present?
        flash[:alert] = t("alert.sent_other")
        redirect_to new_band_scout_path(params[:scout][:scouted_band_id]) and return
      elsif (band_members & scouted_band_members).present?
        flash[:alert] = t("alert.duplicate")
        redirect_to new_band_scout_path(params[:scout][:scouted_band_id]) and return
      elsif band_members.count + scouted_band_members.count > 10
        flash[:alert] = t("alert.over")
        redirect_to new_band_scout_path(params[:scout][:scouted_band_id]) and return
      end
    end
    if @scout.save
      redirect_to scouts_path, notice: t("notice.scout")
    else
      render :new_band, status: :unprocessable_entity
    end
  end

  def received_offer
    @scouts = @user.reverse_of_scouts.where(scouted_band_id: nil).where.not(band_id: nil).page(params[:page])
  end

  def received_join
    @scouts = @user.reverse_of_scouts.where(band_id: nil).where.not(scouted_band_id: nil).page(params[:page])
  end

  def received_marge
    @scouts = @user.reverse_of_scouts.where.not(band_id: nil).where.not(scouted_band_id: nil).page(params[:page])
  end

  def send_new
    @scouts = @user.scouts.where(band_id: nil, scouted_band_id: nil).page(params[:page])
  end

  def send_offer
    @scouts = @user.scouts.where(scouted_band_id: nil).where.not(band_id: nil).page(params[:page])
  end

  def send_join
    @scouts = @user.scouts.where(band_id: nil).where.not(scouted_band_id: nil).page(params[:page])
  end

  def send_marge
    @scouts = @user.scouts.where.not(band_id: nil).where.not(scouted_band_id: nil).page(params[:page])
  end

  def approve_new
    @scout = Scout.find(params[:id])
    @band = Band.create(name: "新規バンド")
    @band.band_members.create(user_id: @scout.user_id, part_id: @scout.part_id, other_part: @scout.other_part, role: "リーダー")
    @band.band_members.create(user_id: @user.id, part_id: @scout.scouted_part_id, other_part: @scout.scouted_other_part, role: "メンバー")
    @scout.destroy
    update_band_colums(@band.id)
    redirect_to bands_path, notice: t("notice.approve")
  end

  def approve_offer
    @scout = Scout.find(params[:id])
    @band = Band.find(@scout.band_id)
    @band.band_members.create(user_id: @user.id, part_id: @scout.scouted_part_id, other_part: @scout.scouted_other_part, role: "メンバー")
    @scout.destroy
    update_band_colums(@band.id)
    redirect_to bands_path, notice: t("notice.approve")
  end

  def approve_join
    @scout = Scout.find(params[:id])
    @band = Band.find(@scout.scouted_band_id)
    @band.band_members.create(user_id: @scout.user_id, part_id: @scout.part_id, other_part: @scout.other_part, role: "メンバー")
    @scout.destroy
    update_band_colums(@band.id)
    redirect_to bands_path, notice: t("notice.approve")
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
    redirect_to bands_path, notice: t("notice.approve")
  end

  def refuse
    @scout = Scout.find(params[:id])
    @scout.destroy
    redirect_to scouts_path, notice: t("notice.refuse")
  end

  private

  def scout_params
    params.require(:scout).permit(:user_id, :scouted_user_id, :band_id, :scouted_band_id, :part_id, :scouted_part_id,
                                  :other_part, :scouted_other_part, :message)
  end

  def set_user
    @user = current_user
  end

  def set_parts
    @parts = Part.where(id: 1..6)
  end

  def set_bands
    @bands = Band.where(id: @user.band_members.where(role: "リーダー").pluck(:band_id))
  end
end
