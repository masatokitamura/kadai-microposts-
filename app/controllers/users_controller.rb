class UsersController < ApplicationController
  before_action :require_user_logged_in, only: [:index, :show]
  def index
    @users = User.order(id: :desc).page(params[:page]).per(25)
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.order(id: :desc).page(params[:page])
    counts(@user)
    @likes = current_user.favpost.order(id: :desc).page(params[:page])
  end

  def new
    @user = User.new
  end

  def create
    @user= User.new(user_params)
    
    if @user.save
      flash[:success] ="ユーザーを登録しました。"
      redirect_to @user
    else
      flash.now[:danger] ="ユーザーの登録に失敗しました。"
      render :new
    end  
  end
  
  def followings
    @user = User.find(params[:id])
    @followings = @user.followings.page(params[:page])
    counts(@user)
  end

  def followers
    @user = User.find(params[:id])
    @followers = @user.followers.page(params[:page])
    counts(@user)
  end
  
  def likes
    @user = User.find(params[:id])
    @favposts = @user.favpost.page(params[:page])
    counts(@user)

  end  
  

 
end

private

def user_params
  params.require(:user).permit(:name, :email, :password, :password_confirmation)
end