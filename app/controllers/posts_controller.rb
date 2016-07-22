class PostsController < ApplicationController
  before_action :find_post, only: [:show, :edit, :update, :destroy]
  skip_before_action :authenticate_user!, only: [:show, :index]

  def new
    @post = Post.new
  end

  def create
    @post = Post.new post_params
    @post.user = current_user

    if @post.save
      redirect_to post_path(@post), notice: "Post created!"
    else
      flash[:alert] = "Post not created!"
      render :new
    end
  end

  def show
    @comment = Comment.new
  end

  def index
    @posts = Post.order("created_at DESC")
  end

  def edit
  end

  def update
    if @post.update post_params
      redirect_to post_path(@post), notice: "Post updated"
    else
      render :edit
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_path, notice: "Post deleted"
  end


  private

  def post_params
    params.require(:post).permit(:title, :body, :image, :address, :longitude, :latitude)
  end

  def find_post
    @post = Post.find params[:id]
  end

  def authorize_owner
    redirect_to root_path, alert: "access denied" unless can? :manage, @post
  end

  def current_user_vote
    @post.vote_for(current_user)
  end
  helper_method :current_user_vote


end
