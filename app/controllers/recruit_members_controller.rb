class RecruitMembersController < ApplicationController
  def new
    @member = RecruitMember.new
    @band = Band.find(params[:id])
    @levels = %W[未経験 初心者 中級者 上級者]
    @parts = Part.all
  end

  def edit
    @member = RecruitMember.find(params[:id])
    @band = Band.find(@member.band_id)
    @levels = %W[未経験 初心者 中級者 上級者]
    @parts = Part.all
  end

  def create
    @member = RecruitMember.new(member_params)
    flash[:notice] = t("notice.create")
    redirect_to band_path(@member.band_id) if @member.save
  end

  def update
    @member = RecruitMember.find(params[:id])
    @member.update(member_params)
    redirect_to band_path(@member.band_id), notice: t("notice.update")
  end

  def destroy
    @member = RecruitMember.find(params[:id])
    @member.destroy
  end

  private

  def member_params
    params.require(:recruit_member).permit(:band_id, :part_id, :level, :other_part, :age, :sex)
  end
end
