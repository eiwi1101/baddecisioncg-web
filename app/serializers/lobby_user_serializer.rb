# == Schema Information
#
# Table name: lobby_users
#
#  id         :integer          not null, primary key
#  lobby_id   :integer
#  user_id    :integer
#  moderator  :boolean
#  admin      :boolean
#  deleted_at :datetime
#  guid       :string
#  name       :string
#

class LobbyUserSerializer < ActiveModel::Serializer
  attributes :id, :avatar_url, :name, :admin, :moderator, :username, :is_deleted

  def id
    object.guid
  end

  def username
    object.user&.username
  end

  def is_deleted
    object.deleted?
  end
end
