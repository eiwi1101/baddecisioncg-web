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

  attributes :id, :name, :new_message_url, :new_game_url

  def id
    object.token
  end

  def new_message_url
    lobby_messages_path object
  end

  def new_game_url
    lobby_games_path object
  end
end
