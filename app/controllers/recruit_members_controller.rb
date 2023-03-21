class RecruitMembersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_parts, :set_levels, only: %i[new edit create update]
  def new
    @member = RecruitMember.new
    @band = Band.find(params[:id])
  end

  def edit
    @member = RecruitMember.find(params[:id])
    @band = Band.find(@member.band_id)
  end

  def create
    @member = RecruitMember.new(member_params)
    @band = Band.find(params[:recruit_member][:band_id])
    if @member.save
      flash[:notice] = t("notice.create")
      redirect_to band_path(@member.band_id)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @member = RecruitMember.find(params[:id])
    @band = Band.find(@member.band_id)
    if @member.update(member_params)
      redirect_to band_path(@member.band_id), notice: t("notice.update")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @member = RecruitMember.find(params[:id])
    @member.destroy
  end

  private

  def member_params
    params.require(:recruit_member).permit(:band_id, :part_id, :level, :other_part, :age, :sex)
  end

  def set_parts
    @parts = Part.all
  end

  def set_levels
    @levels = %W[未経験 初心者 中級者 上級者]
  end
end
