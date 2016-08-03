class UsersController < ApplicationController
  before_action :find_user, only: [:edit, :update, :edit_password, :update_password]

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      sign_in(@user)
      redirect_to posts_path, notice: "You're now signed up!"
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update user_params
      redirect_to posts_path, notice: "Information updated!"
    else
      render :edit
    end
  end

  def edit_password
  end

  def update_password
    if @user.authenticate(user_params[:password]) && @user.authenticate(user_params[:new_password]) == false
      @user.update(password: user_params[:new_password], password_confirmation: user_params[:password_confirmation])
      redirect_to posts_path, notice: "Password updated!"
    else
      if @user.authenticate(user_params[:password]) == false
        flash[:alert] = "Incorrect password"
      elsif @user.authenticate(user_params[:new_password])
        flash[:alert] = "The new password should be different from the current password"
      end
      render :edit_password
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :new_password, :password_confirmation)
  end

  def find_user
    @user = current_user
  end
end
