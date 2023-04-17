class BandMembersController < ApplicationController
  before_action :authenticate_user!
  def edit
    @member = BandMember.find(params[:id])
    @band = @member.band
    @parts = Part.where(id: 1..6)
    redirect_to user_bands_bands_path, alert: t("alert.page_unavailable") unless @band.band_members.find_by(role: "リーダー").user == current_user
  end

  def update
    @member = BandMember.find(params[:id])
    @parts = Part.where(id: 1..6)
    @band = @member.band
    if params[:band_member][:role] == "リーダー"
      reader = @band.band_members.find_by(role: "リーダー")
      reader.update(role: "メンバー")
    end
    if @member.update(member_params)
      redirect_to band_path(@band.id), notice: t("notice.update")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @member = BandMember.find(params[:id])
    member = @member.user
    @band = @member.band
    if @member.role == "リーダー"
      other_member = @band.band_members.find_by(role: "メンバー")
      other_member.update!(role: "リーダー")
    end
    @member.destroy
    update_band_colums(@band)
    if @band.band_members.count <= 1
      @band.destroy
      redirect_to bands_path, notice: t("notice.broke_up_band") and return
    end
    if member == current_user
      redirect_to bands_path, notice: t("notice.leave_band")
    else
      redirect_to band_path(@band.id), notice: t("notice.kick_out")
    end
  end

  private

  def member_params
    params.require(:band_member).permit(:band_id, :part_id, :other_part, :role)
  end
end
