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
  attributes :guid, :avatar_url, :name, :admin, :moderator, :username

  has_one :user, serializer: UserSerializer

  def username
    object.user&.username
  end
end
