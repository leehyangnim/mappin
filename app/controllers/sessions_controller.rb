class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by_email params[:email]
    if user && user.authenticate(params[:password])
      sign_in(user)
      redirect_to root_path, notice: "Signed In! Welcome back."
    elsif user
      flash[:alert] = "Wrong password!"
      render :new
    else
      if params[:email] != nil
        redirect_to new_user_path, alert: "Hummm, we couldn't find an account with #{params[:email]}. Consider signing up!"
      end
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: "Signed Out!"
  end

end
