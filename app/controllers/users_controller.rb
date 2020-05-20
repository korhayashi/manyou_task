class UsersController < ApplicationController
  before_action :logged_in, only: [:new, :create]
  before_action :not_logged_in, only: [:show]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to root_path
    else
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
    @tasks = @user.tasks.sorted.kaminari(params[:page])
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
