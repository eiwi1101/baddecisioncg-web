# == Schema Information
#
# Table name: lobbies
#
#  id         :integer          not null, primary key
#  name       :string
#  private    :boolean
#  token      :string
#  password   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  deleted_at :datetime
#

class LobbySerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :token, :name, :message_url

  def message_url
    lobby_messages_path object
  end
end
