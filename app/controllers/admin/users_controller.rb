class Admin::UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update, :destroy]
  before_action :not_logged_in
  before_action :not_admin_user

  def index
    @users = User.all.includes(:tasks)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to user_path(@user.id)
    else
      render :new
    end
  end

  def edit

  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user.id), notice: 'ユーザー情報を変更しました'
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      redirect_to admin_users_path, notice: "#{@user.name}さんのユーザーデータを削除しました"
    else
      redirect_to admin_users_path, notice: "最低一人の管理者が必要なため#{@user.name}さんを削除できません"
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :admin)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def not_admin_user
    if current_user.admin == false
      redirect_to root_path, notice: 'アクセス権限がありません'
    end
  end
end
