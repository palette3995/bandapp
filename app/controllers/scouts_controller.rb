class ScoutsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_parts, :set_bands, only: %i[new_user new_band create create_band]

  def new_user
    @scout = Scout.new
    @scouted_user = User.find(params[:id])
    redirect_to users_path, alert: t("alert.page_unavailable") if @scouted_user == current_user
  end

  def new_band
    @scout = Scout.new
    @scouted_band = Band.find(params[:id])
    scouted_band_members = @scouted_band.band_members
    @reader = scouted_band_members.find_by(role: "リーダー").user
    redirect_to bands_path, alert: t("alert.page_unavailable") if scouted_band_members.map(&:user).include?(current_user)
  end

  def index
    @scouts = current_user.reverse_of_scouts.includes(user: { image_attachment: :blob }).where(band_id: nil, scouted_band_id: nil).page(params[:page])
  end

  def create
    @scout = Scout.new(scout_params)
    @scouted_user = User.find(params[:scout][:scouted_user_id])
    if params[:scout][:band_id].present?
      band = Band.find(params[:scout][:band_id])
      alerts_band_scouts_user(@scouted_user, band)
    end
    if flash.now[:alert].nil? && @scout.save
      redirect_to scouts_path, notice: t("notice.scout")
    else
      render :new_user, status: :unprocessable_entity
    end
  end

  def create_band
    @scout = Scout.new(scout_params)
    @scouted_band = Band.find(params[:scout][:scouted_band_id])
    @reader = @scouted_band.band_members.find_by(role: "リーダー").user
    if params[:scout][:band_id]
      band = Band.find(params[:scout][:band_id])
      alerts_already_scouted(band, @scouted_band)
      alerts_already_scouted_from_member(band, @scouted_band)
      flash.now[:alert] = t("alert.duplicate") if (band.band_members.map(&:user) & @scouted_band.band_members.map(&:user)).present?
      flash.now[:alert] = t("alert.over") if band.band_members.count + @scouted_band.band_members.count > 10
    end
    if flash.now[:alert].nil? && @scout.save
      redirect_to scouts_path, notice: t("notice.scout")
    else
      render :new_band, status: :unprocessable_entity
    end
  end

  def received_offer
    @scouts = current_user.reverse_of_scouts.includes(:users, band: { image_attachment: :blob }).where(scouted_band_id: nil).where.not(band_id: nil).page(params[:page])
  end

  def received_join
    @scouts = current_user.reverse_of_scouts.includes(:scouted_bands, user: { image_attachment: :blob }).where(band_id: nil).where.not(scouted_band_id: nil).page(params[:page])
  end

  def received_marge
    @scouts = current_user.reverse_of_scouts.includes(:users, :scouted_bands, band: { image_attachment: :blob }).where.not(band_id: nil).where.not(scouted_band_id: nil).page(params[:page])
  end

  def send_new
    @scouts = current_user.scouts.includes(scouted_user: { image_attachment: :blob }).where(band_id: nil, scouted_band_id: nil).page(params[:page])
  end

  def send_offer
    @scouts = current_user.scouts.includes(:bands, scouted_user: { image_attachment: :blob }).where(scouted_band_id: nil).where.not(band_id: nil).page(params[:page])
  end

  def send_join
    @scouts = current_user.scouts.includes(scouted_band: { image_attachment: :blob }).where(band_id: nil).where.not(scouted_band_id: nil).page(params[:page])
  end

  def send_marge
    @scouts = current_user.scouts.includes(:bands, scouted_band: { image_attachment: :blob }).where.not(band_id: nil).where.not(scouted_band_id: nil).page(params[:page])
  end

  def approve_new
    @scout = Scout.find(params[:id])
    @band = Band.create(name: "新規バンド")
    @band.band_members.create(user_id: @scout.user_id, part_id: @scout.part_id, other_part: @scout.other_part, role: "リーダー")
    @band.band_members.create(user_id: current_user.id, part_id: @scout.scouted_part_id, other_part: @scout.scouted_other_part, role: "メンバー")
    @scout.destroy
    update_band_colums(@band)
    redirect_to bands_path, notice: t("notice.approve")
  end

  def approve_offer
    @scout = Scout.find(params[:id])
    @band = @scout.band
    if @band.band_members.count < 10
      @band.band_members.create(user_id: current_user.id, part_id: @scout.scouted_part_id, other_part: @scout.scouted_other_part, role: "メンバー")
      @scout.destroy
      update_band_colums(@band)
      redirect_to bands_path, notice: t("notice.approve")
    else
      render :received_offer, alert: t("alert.upper_limit"), status: :unprocessable_entity
    end
  end

  def approve_join
    @scout = Scout.find(params[:id])
    @band = @scout.scouted_band
    if @band.band_members.count < 10
      @band.band_members.create(user_id: @scout.user_id, part_id: @scout.part_id, other_part: @scout.other_part, role: "メンバー")
      @scout.destroy
      update_band_colums(@band)
      redirect_to bands_path, notice: t("notice.approve")
    else
      render :received_join, alert: t("alert.upper_limit"), status: :unprocessable_entity
    end
  end

  def approve_marge
    @scout = Scout.find(params[:id])
    @band = Band.create(name: "新規バンド")
    if @scout.band.band_members.count + @scout.scouted_band.band_members.count <= 10
      @scout.create_new_band_members(@band)
      @scout.after_marge_bands
      update_band_colums(@band)
      redirect_to bands_path, notice: t("notice.approve")
    else
      render :received_marge, alert: t("alert.upper_limit"), status: :unprocessable_entity
    end
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

  def set_parts
    @parts = Part.where(id: 1..6)
  end

  def set_bands
    @bands = Band.where(id: current_user.band_members.where(role: "リーダー").pluck(:band_id))
  end

  def alerts_band_scouts_user(user, band)
    if user.band_scouted_mes.include?(band)
      flash.now[:alert] = t("alert.sent")
    elsif band.user_scouted_mes.include?(user)
      flash.now[:alert] = t("alert.received")
    elsif user.bands.include?(band)
      flash.now[:alert] = t("alert.registered")
    end
  end

  def alerts_already_scouted(band, scouted_band)
    if band.already_scouted?(scouted_band)
      flash.now[:alert] = t("alert.received")
    elsif scouted_band.already_scouted?(band)
      flash.now[:alert] = t("alert.sent")
    end
  end

  def alerts_already_scouted_from_member(band, scouted_band)
    if band.already_scouted_from_member?(scouted_band)
      flash.now[:alert] = t("alert.received_other")
    elsif scouted_band.already_scouted_from_member?(band)
      flash.now[:alert] = t("alert.sent_other")
    end
  end
end
