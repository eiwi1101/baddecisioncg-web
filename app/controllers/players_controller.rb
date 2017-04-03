class PlayersController < ApplicationController
  before_action :get_game

  def create
    lobby_user = LobbyUser.find(params[:user_id])
    @player = @game.join(lobby_user)
    respond_with @player, serializer: PlayerSerializer
  end

  private

  def get_game
    @game = Game.find(params[:game_id])
  end
end
