class GameLobbyUserSerializer < ActiveModel::Serializer
  attributes :guid
  has_one :user, serializer: UserSerializer
  has_one :game_lobby, serializer: GameLobbySerializer
end
