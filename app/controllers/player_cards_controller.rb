class PlayerCardsController < ApplicationController
  before_action :get_round, only: [:create, :winner]
  before_action :get_player, only: [:create, :winner]

  def create
    if @round
      player_card = @player.player_cards.find_by! guid: params[:player_card_id]
      @round.play @player, player_card
    else
      flash.now[:error] = t('violations.round_order')
    end
  end

  def winner
    if @round
      player_card = @round.player_cards.find_by! guid: params[:player_card_id]
      @round.bard_pick @player, player_card
    else
      flash.now[:error] = t('violations.round_order')
    end
  end

  private

  def get_round
    @round = Round.find_by!(guid: params[:round_id])
  end

  def get_player
    @player = @round.game.player_for current_lobby_user
  end
end
