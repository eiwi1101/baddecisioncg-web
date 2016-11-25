# == Schema Information
#
# Table name: game_lobbies
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

class GameLobby < ApplicationRecord
  include HasGuid

  has_many :games
  has_many :game_lobby_users
  has_many :users, through: :game_lobby_users
  has_many :messages

  has_guid :token, type: :token
  acts_as_paranoid

  validates_presence_of :name

  def join(user, password=nil)
    raise Exceptions::LobbyClosedViolation.new if deleted?

    if has_password?
      raise Exceptions::LobbyPermissionViolation.new if password != self.password
    end

    game_lobby_users << GameLobbyUser.new(user: user)
  end

  def leave(user)
    raise Exceptions::LobbyClosedViolation.new if deleted?

    game_lobby_user = game_lobby_users.find_by!(user: user)
    game_lobby_users.delete(game_lobby_user)

    if current_game&.has_lobby_user?(game_lobby_user)
      current_game.leave(game_lobby_user)
    end

    if game_lobby_users.admins.length == 0
      game_lobby_users.first.try(:update_attributes, admin: true)
    end

    if game_lobby_users.length == 0
      self.delete
    end
  end

  def current_game
    games.last
  end

  def has_password?
    password.present?
  end
end
