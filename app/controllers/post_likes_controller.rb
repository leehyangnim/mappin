class PostLikesController < ApplicationController
  before_action :authenticate_user!

  def create
    @post = Post.find params[:post_id]
    post_like = PostLike.new(user: current_user, post: @post)
    post_like.save
    respond_to do |format|
      format.html { redirect_to root_path, notice: "Liked!" }
      format.js { render}
    end
  end

  def destroy
    post_like = PostLike.find params[:id]
    @post = Post.find params[:post_id]
    post_like.destroy
    respond_to do |format|
      format.html { redirect_to root_path, notice: "Unliked!" }
      format.js { render }
    end
  end
end
