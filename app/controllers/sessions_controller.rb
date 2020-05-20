class SessionsController < ApplicationController
  before_action :logged_in, only: [:new, :create]
  before_action :not_logged_in, only: [:destroy]

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      session[:user_id] = user.id
      redirect_to root_path
    else
      flash.now[:danger] = 'ログインに失敗しました。メールアドレスかパスワードが間違っています。'
      render :new
    end
  end

  def destroy
    session.delete(:user_id)
    flash[:notice] = 'ログアウトしました'
    redirect_to new_session_path
  end
end
