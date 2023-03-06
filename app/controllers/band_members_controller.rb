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
  end

  private

  def member_params
    params.require(:band_member).permit(:band_id, :part_id, :other_part, :role)
  end
end
