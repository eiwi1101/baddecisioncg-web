class Players::CardsController < ApplicationController
  before_action :get_player

  def index
    @player_cards = @player.player_cards.in_hand
    respond_with @player_cards, each_serializer: PlayerCardSerializer, location: nil
  end

  def create; end # draw
  def update; end # play

  private

  def get_player
    @player = Player.find_by! guid: params[:player_id]

    if !current_lobby_user(@player.lobby)
      head :unauthorized
      false
    end
    true
  end
end
