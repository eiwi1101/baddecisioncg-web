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

  attributes :id,
             :current_game_id,
             :name,
             :path

  def id
    object.token
  end

  def current_game_id
    object.current_game&.guid
  end

  def path
    lobby_path object
  end
end
