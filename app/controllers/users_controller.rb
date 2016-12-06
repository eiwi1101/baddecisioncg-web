class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.create(user_params)

    if @user.save
      redirect_to game_lobbies_path, flash: { notice: t('session.register_success') }
    else
      render 'new'
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :display_name, :email, :password, :password_confirmation)
  end
end
