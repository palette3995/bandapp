class UsersController < ApplicationController
  def index
  end

  def show
  end

  def mypage
    @user = User.find(current_user.id)
  end

  def edit
    @user = User.find(current_user.id)
  end

  def update
  end
end
