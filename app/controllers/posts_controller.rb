class PostsController < ApplicationController
  before_action :authenticate_user!
  def new
    @post = Post.new
    @post.photos.build
  end

  def create
    @post = Post.new(post_params)
    if @post.photos.present?
      @post.save
      redirect_to root_path
      flash[:notice] = "質問が保存されました"
    else
      redirect_to root_path
      flash[:alert] = "質問の投稿にに失敗しました"
    end
  end

  def index
    @posts = Post.limit(8).includes(:photos, :user).order('created_at DESC')
  end

  def show
    @post = Post.find_by(id: params[:id])
  end
  
  def destroy
    @post = Post.find_by(id: params[:id])
    if @post.user == current_user
      flash[:notice] = "投稿が削除されました" if @post.destroy
    else
      flash[:alert] = "投稿の削除に失敗しました"
    end
    redirect_to root_path
  end
  private
    def post_params
      params.require(:post).permit(:explanation, photos_attributes: [:image]).merge(user_id: current_user.id)
    end

end
