# == Schema Information
#
# Table name: games
#
#  id              :integer          not null, primary key
#  score_limit     :integer
#  lobby_id        :integer
#  winning_user_id :integer
#  status          :string
#  guid            :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class GameSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :guid, :score_limit, :status, :join_url, :start_url, :play_card_url, :winner_card_url, :players

  has_one  :current_round

  def players
    Hash[object.players.collect { |u| [ u.guid, PlayerSerializer.new(u) ] }]
  end

  def start_url
    start_game_path object
  end

  def join_url
    game_players_path object
  end

  def play_card_url
    round_player_cards_path object.current_round if object.current_round
  end

  def winner_card_url
    winner_round_player_cards_path object.current_round if object.current_round
  end
end
