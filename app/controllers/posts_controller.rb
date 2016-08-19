class PostsController < ApplicationController
  before_action :find_post, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  def new
    @post = Post.new
    @longitude = params[:longitude]
    @latitude = params[:latitude]
    render partial: 'new'
  end

  def create
    @post = Post.new post_params
    @post.body = emojify(post_params[:body])
    @post.title = emojify(post_params[:title])
    @post.user = current_user

    if @post.save
      redirect_to posts_path, notice: "Post created!"
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

    @markers_hash =  Gmaps4rails.build_markers(@posts) do |post, marker|
                        marker.lat post.latitude
                        marker.lng post.longitude
                        marker.infowindow render_to_string partial: 'show', locals: {post: post}
                        marker.json(id: post.id)
                      end
  end

  def cluster
    @marker_ids = params[:marker_ids]
    render paritial: "cluster", :layout => false
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
    respond_to do |format|
      format.html { redirect_to posts_path, notice: "Post deleted" }
      # format.js {render :destroy_success}
      format.js { render } # render /app/views/answers/destroy.js.erb
    end
  end


  private

  def post_params
    params.require(:post).permit(:title, :body, :image, :address, :longitude, :latitude,  {image: []})
  end

  def find_post
    @post = Post.find params[:id]
  end

  def authorize_owner
    redirect_to posts_path, alert: "access denied" unless can? :manage, @post
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
