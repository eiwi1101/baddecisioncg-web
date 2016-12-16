class PlayersController < ApplicationController
  before_action :get_game

  def create
    lobby_user = LobbyUser.find(params[:user_id])
    @game.join(lobby_user)
    flash.now[:notice] = t('game_status.joined')
  end

  private

  def get_game
    @game = Game.find(params[:game_id])
  end
end
