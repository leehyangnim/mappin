class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_post

  def create
    @comment = Comment.new comment_params
    @comment.post = post

    if @comment.save
      redirect_to post_path(post), notice: "Comment created"
    else
      render "/posts/show"
    end
  end

  def destroy
    @comment  = Comment.find params[:id]
    @comment.destroy
    redirect_to post_path(post), notice: "Comment deleted" }
  end

  private

  def find_post
    post = Post.find params[:post_id]
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

end
