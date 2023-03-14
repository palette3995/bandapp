class ChatsController < ApplicationController
  def show
    @band = Band.find(params[:id])
    @chats = Chat.where(band_id: params[:id]).order(created_at: :desc)
    @chat = Chat.new
  end

  def create
    @chat = Chat.new(chat_params)
    redirect_to chat_path(params[:chat][:band_id]) if @chat.save
  end

  private

  def chat_params
    params.require(:chat).permit(:user_id, :band_id, :message)
  end
end
