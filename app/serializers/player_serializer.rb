class PlayerSerializer < ActiveModel::Serializer
  attributes :guid, :lobby_user_id, :score

  def lobby_user_id
    object.lobby_user.guid
  end
end
