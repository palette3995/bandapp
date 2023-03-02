class BandsController < ApplicationController
  def index
    @user = current_user
    @bands = @user.bands
  end

  def show
    @band = Band.find(params[:id])
  end

  def edit
    @band = Band.find(params[:id])
  end

  def create
  end

  def update
  end

  def destroy
  end
end
