class PlayersController < ApplicationController
  before_action :get_lobby

  def create
    game = @lobby.current_game || Game.create(lobby: @lobby)
    Rails.logger.info game.inspect
    lobby_user = LobbyUser.find(params[:player][:lobby_user_id])
    Rails.logger.info lobby_user.inspect

    game.join(lobby_user)
    flash.now[:notice] = 'Joined! You will be dealt in when the game starts.'
  rescue Exceptions::RuleViolation => e
    flash.now[:error] = e.message
  end

  private

  def get_lobby
    @lobby = Lobby.find(params[:lobby_id])
  end
end
