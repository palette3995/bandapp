class BandMembersController < ApplicationController
  def edit
    @member = BandMember.find(params[:id])
    @band = @member.band
    @parts = Part.where(id: 1..6)
  end

  def update
    @member = BandMember.find(params[:id])
    @band = @member.band
    if params[:band_member][:role] == "リーダー"
      reader = @band.band_members.find_by(role: "リーダー")
      reader.update(role: "メンバー")
    end
    @member.update(member_params)
    redirect_to band_path(@band.id)
  end

  def destroy
    @member = BandMember.find(params[:id])
    @band = @member.band
    if @member.role == "リーダー"
      other_member = @band.band_members.where.not(id: @member.id).first
      other_member.update!(role: "リーダー")
    end
    @member.destroy
    update_band_colums(@band.id)
  end

  private

  def member_params
    params.require(:band_member).permit(:band_id, :part_id, :other_part, :role)
  end
end
