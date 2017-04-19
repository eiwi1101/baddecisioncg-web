class Rounds::WinnersController < ApplicationController
  before_action :get_round
  before_action :get_card, only: [:create]

  def create
    @round.bard_pick @player, @card
    respond_with @card, serializer: PlayerCardSerializer, location: nil
  end

  private

  def get_card
    @player = current_lobby_user(@round.lobby).current_player

    if @player.bard?
      @card = @round.player_cards.find_by! guid: params[:card_id]
    else
      head :unauthorized
      false
    end
  end

  def get_round
    @round = Round.find_by! guid: params[:round_id]
  end
end
