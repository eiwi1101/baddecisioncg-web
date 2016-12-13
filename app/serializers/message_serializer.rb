class MessageSerializer < ActiveModel::Serializer
  attributes :guid, :message, :created_at, :lobby_user_guid

  def lobby_user_guid
    object.lobby_user.guid
  end

  has_one :lobby_user, serializer: LobbyUserSerializer
end
