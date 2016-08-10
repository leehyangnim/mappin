class PostLikesController < ApplicationController
  before_action :authenticate_user!

  def create
    @post = Post.find params[:post_id]
    post_like = PostLike.new(user: current_user, post: @post)
    post_like.save
    create_notification(@post, post_like)
    respond_to do |format|
      format.html { redirect_to posts_path, notice: "Liked!" }
      format.js { render}
    end
  end

  def destroy
    post_like = PostLike.find params[:id]
    @post = Post.find params[:post_id]
    post_like.destroy
    respond_to do |format|
      format.html { redirect_to posts_path, notice: "Unliked!" }
      format.js { render }
    end
  end

  private

  def create_notification(post, post_like)
    return if post.user.id == current_user.id
    Notification.create(user: post.user,
                        notified_by: current_user,
                        post: post,
                        identifier: post_like.id,
                        notice_type: 'like')
  end
end
