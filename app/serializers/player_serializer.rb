# == Schema Information
#
# Table name: players
#
#  id            :integer          not null, primary key
#  game_id       :integer
#  lobby_user_id :integer
#  score         :integer
#  order         :integer
#  guid          :string
#  deleted_at    :datetime
#

class PlayerSerializer < ActiveModel::Serializer
  attributes :guid, :lobby_user_id, :score, :name, :avatar_url, :is_deleted

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
    object.deleted?
  end
end
