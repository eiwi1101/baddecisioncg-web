class LobbyUserSerializer < ActiveModel::Serializer
  attributes :guid
  has_one :user, serializer: UserSerializer
  has_one :lobby, serializer: LobbySerializer
end
