class CallbacksController < ApplicationController
  def facebook
    facebook_data = request.env['omniauth.auth']
    user = User.find_or_create_from_facebook facebook_data
    sign_in(user)
    redirect_to root_path, notice: "Signed in with Facebook! Welcome back, #{user.email}"
  end
end
