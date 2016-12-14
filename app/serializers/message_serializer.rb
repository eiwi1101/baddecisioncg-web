# == Schema Information
#
# Table name: messages
#
#  id         :integer          not null, primary key
#  lobby_id   :integer
#  user_id    :integer
#  message    :text
#  guid       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class MessageSerializer < ActiveModel::Serializer
  attributes :guid, :message, :created_at, :lobby_user_guid

  def lobby_user_guid
    object.lobby_user.guid
  end

  has_one :lobby_user, serializer: LobbyUserSerializer
end
