class RoundsController < ApplicationController
  before_action :get_game, only: [:create]

  def create
    @round = @game.next_round
    respond_with @round, serializer: RoundSerializer
  end

  private

  def get_game
    @game = Game.find_by!(guid: params[:game_id])
  end
end
