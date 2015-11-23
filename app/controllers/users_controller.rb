class UsersController < ApplicationController

  def show
    @user = User.first
  end

  def edit
    @user = User.first
  end

  def update
    @user = User.first
    if @user.update user_params
      redirect_to user_path, notice: 'Successfully updated admin.'
    else
      render 'edit'
    end
  end

private

  def user_params
    params.require(:user).permit!
  end

end