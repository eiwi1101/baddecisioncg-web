class RoundsController < ApplicationController
  before_action :get_game, only: [:create]

  def create
    @game.next_round
  end

  private

  def get_game
    @game = Game.find_by!(guid: params[:game_id])
  end
end
