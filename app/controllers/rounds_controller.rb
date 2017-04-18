class RoundsController < ApplicationController
  before_action :get_game, only: [:create]
  before_action :get_round, only: [:show]

  def create
    @round = @game.next_round
    respond_with @round, serializer: RoundSerializer, location: nil
  end

  def show
    respond_with @round, serializer: RoundSerializer, location: nil
  end

  private

  def get_round
    @round = Round.find_by!(guid: params[:id])
  end

  def get_game
    @game = Game.find_by!(guid: params[:game_id])
  end
end
