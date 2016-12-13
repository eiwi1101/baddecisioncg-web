class LobbyStateSerializer < ActiveModel::Serializer
  attributes :lobby, :game, :users

  has_many :messages, serializer: MessageSerializer

  def lobby
    LobbySerializer.new object
  end

  def game
    GameSerializer.new object.current_game
  end

  def users
    Hash[object.lobby_users.collect { |u| [ u.guid, LobbyUserSerializer.new(u) ] }]
  end
end
