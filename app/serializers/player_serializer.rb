class PlayerSerializer < ActiveModel::Serializer
  attributes :guid, :lobby_user_id, :score, :name, :avatar_url

  def name
    object.lobby_user.name
  end

  def avatar_url
    object.lobby_user.avatar_url
  end

  def score
    object.score || 0
  end

  def lobby_user_id
    object.lobby_user.guid
  end

  def is_deleted
    self.deleted?
  end
end
