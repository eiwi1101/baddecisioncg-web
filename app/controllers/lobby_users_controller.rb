class LobbyUsersController < ApplicationController
  before_action :get_lobby_user, only: [:destroy]

  def destroy
    lobby_user&.leave!
    redirect_to lobbies_path, flash: { notice: 'Thanks for playing!' }
  end

  private

  def get_lobby_user
    @lobby_user = LobbyUser.find_by!(guid: params[:id])
  end
end
