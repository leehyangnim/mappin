class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @comment = Comment.new comment_params
    @comment.post = Post.find params[:post_id]
    @comment.user = current_user

    respond_to do |format|
      if @comment.save
        format.html { redirect_to posts_path, notice: "Comment created"}
        format.js { render :create_success }
      else
        format.html { render "/posts/show" }
        format.js { render :create_failure }
      end
    end
  end

  def destroy
    post = Post.find params[:post_id]
    @comment  = Comment.find params[:id]
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to posts_path, notice: "Comment deleted" }
      # format.js {render :destroy_success}
      format.js { render } # render /app/views/answers/destroy.js.erb
    end

  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

end
