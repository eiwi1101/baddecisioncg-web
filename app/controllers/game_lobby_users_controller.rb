class GameLobbyUsersController < ApplicationController
  before_action :get_game_lobby_user, only: [:destroy]

  def destroy
    @game_lobby_user&.leave!
    redirect_to game_lobbies_path, flash: { notice: 'Thanks for playing!' }
  end

  private

  def get_game_lobby_user
    @game_lobby_user = GameLobbyUser.find_by!(guid: params[:id])
  end
end
