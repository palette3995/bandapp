class BandsController < ApplicationController
  def index
    @user = current_user
    @bands = @user.bands
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
  end

  def update
  end

  def destroy
  end
end
