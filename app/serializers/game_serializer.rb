class GameSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :score_limit, :status, :join_url, :start_url, :players

  has_one  :current_round

  def players
    Hash[object.players.collect { |u| [ u.guid, PlayerSerializer.new(u) ] }]
  end

  def start_url
    start_lobby_game_path object.lobby, object
  end

  def join_url
    lobby_game_players_path object.lobby, object
  end
end
