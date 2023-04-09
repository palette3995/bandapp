class ChatsController < ApplicationController
  before_action :authenticate_user!
  def show
    @band = Band.find(params[:id])
    @chats = Chat.eager_load(user: { image_attachment: :blob }).where(band_id: params[:id]).order(created_at: :desc).page(params[:page])
    @chat = Chat.new
    redirect_to user_bands_bands_path, alert: t("alert.page_unavailable") unless @band.users.include?(current_user)
  end

  def create
    @chat = Chat.new(chat_params)
    @band = Band.find(params[:chat][:band_id])
    if @chat.save
      redirect_to chat_path(@band.id)
    else
      render :show, status: :unprocessable_entity
    end
  end

  private

  def chat_params
    params.require(:chat).permit(:user_id, :band_id, :message)
  end
end
