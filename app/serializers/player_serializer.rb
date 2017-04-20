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
  attributes :id,
             :user_id,
             :score,
             :name,
             :avatar_url,
             :score,
             :is_deleted

  def id
    object.guid
  end

  def user_id
    object.lobby_user&.guid
  end

  def name
    object.lobby_user&.name
  end

  def avatar_url
    object.lobby_user&.avatar_url
  end

  def score
    object.score || 0
  end

  def is_deleted
    object.deleted?
  end
end
