class SessionsController < ApplicationController

  before_action :redirect_logged_in, except: [:destroy]

  def new
    @user = User.new

    if params.include? :next
      session[:login_next_path] = params[:next]
      flash.now[:error] = t('session.access_denied')
    else
      session.delete :login_next_path
    end
  end

  def create
    @user = User.find_by(username: params[:user][:username])

    if @user.try :authenticate, params[:user][:password]
      log_in @user
      redirect_to recall_path
    else
      sleep(Random.rand(0.1..0.5))
      @user ||= User.new
      flash.now[:error] = t('session.login_invalid')
      render 'new'
    end
  end

  def destroy
    log_out
    redirect_to root_path
  end

  private

  def redirect_logged_in
    if logged_in?
      redirect_to game_lobbies_path
    end
  end

  def recall_path
    params[:next] || session[:login_next_path] || game_lobbies_path
  end

end
