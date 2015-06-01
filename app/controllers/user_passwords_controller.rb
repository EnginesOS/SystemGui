class UserPasswordsController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = User.first
  end

  def edit
    @user = User.first
  end

  def update
    @user = User.first
    if @user.update user_params
      redirect_to new_user_session_path, notice: 'Admin password has been changed. Please log in again.'
    else
      render 'edit'
    end
  end

private

  def user_params
    p = params.require(:user).permit!
    if p[:password].empty?
      p.delete(:password)
      p.delete(:password_confirmation)
    end
    p
  end

end