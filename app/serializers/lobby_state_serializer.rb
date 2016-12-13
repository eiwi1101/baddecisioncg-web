class LobbyStateSerializer < ActiveModel::Serializer
  attributes :lobby, :game, :users

  has_many :messages, serializer: MessageSerializer

  def lobby
    LobbySerializer.new object
  end

  def game
    if object.current_game
      GameSerializer.new object.current_game
    else
      { players: {}, status: nil }
    end
  end

  def users
    Hash[object.lobby_users.collect { |u| [ u.guid, LobbyUserSerializer.new(u) ] }]
  end
end
