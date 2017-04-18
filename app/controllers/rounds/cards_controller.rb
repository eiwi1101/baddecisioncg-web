class Rounds::CardsController < ApplicationController
  before_action :get_round
  before_action :get_card, only: [:create]

  def create
    if @player.bard?
      @round.bard_play @card
    else
      @round.player_play @card
    end

    respond_with @card, serializer: PlayerCardSerializer, location: nil
  end

  private

  def get_card
    @player = current_lobby_user(@round.lobby).current_player
    @card = @player.player_cards.find_by! guid: params[:card_id]
  end

  def get_round
    @round = Round.find_by! guid: params[:round_id]
  end
end
