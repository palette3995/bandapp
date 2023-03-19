class ChatsController < ApplicationController
  def show
    @band = Band.find(params[:id])
    @chats = Chat.where(band_id: params[:id]).order(created_at: :desc).page(params[:page])
    @chat = Chat.new
  end

  def create
    @chat = Chat.new(chat_params)
    if @chat.save
      redirect_to chat_path(params[:chat][:band_id])
    else
      render :show, status: :unprocessable_entity
    end
  end

  private

  def chat_params
    params.require(:chat).permit(:user_id, :band_id, :message)
  end
end
