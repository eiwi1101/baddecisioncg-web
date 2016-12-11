class GameSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :score_limit, :status, :join_url

  def join_url
    lobby_game_players_path object.lobby, object
  end
end
