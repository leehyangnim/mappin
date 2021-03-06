class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @comment = Comment.new comment_params
    @comment.body = emojify(comment_params[:body])
    @post = Post.find params[:post_id]
    @comment.post = @post
    @comment.user = current_user
    @comments = @post.comments

    respond_to do |format|
      if @comment.save
        create_notification(@post, @comment)
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
      format.js { render }
    end

  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def create_notification(post, comment)
    return if post.user.id == current_user.id
    Notification.create(user: post.user,
                        notified_by: current_user,
                        post: post,
                        identifier: comment.id,
                        notice_type: 'comment')
  end

  def emojify(content)
    content.gsub(/:([\w+-]+):/) do |match|
      if emoji = Emoji.find_by_alias($1)
        Emoji.find_by_alias($1).raw
      else
        match
      end
    end
  end

end
