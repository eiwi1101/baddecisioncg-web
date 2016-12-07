class MessageSerializer < ActiveModel::Serializer
  attributes :guid, :message, :created_at

  has_one :lobby_user, serializer: LobbyUserSerializer
end
