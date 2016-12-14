class PlayersController < ApplicationController
  before_action :get_game
  before_action :get_lobby

  def create
    lobby_user = LobbyUser.find(params[:user_id])
    @game.join(lobby_user)
    flash.now[:notice] = t('game_status.joined')
  rescue Exceptions::RuleViolation => e
    flash.now[:error] = e.message
  end

  private

  def get_lobby
    @lobby = Lobby.find(params[:lobby_id])
  end

  def get_game
    @game = Game.find(params[:game_id])
  end
end
