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

    if has_user? user
      game_lobby_user = game_lobby_users.find_by(user: user)
    else
      game_lobby_user = GameLobbyUser.new(user: user, admin: game_lobby_users.empty?)
      game_lobby_users << game_lobby_user
    end

    broadcast game_lobby_user
    game_lobby_user
  end

  def leave(user)
    raise Exceptions::LobbyClosedViolation.new if deleted?

    game_lobby_user = game_lobby_users.find_by!(user: user)
    game_lobby_users.delete(game_lobby_user)

    if current_game&.has_lobby_user?(game_lobby_user)
      current_game.leave(game_lobby_user)
      broadcast game_lobby_user
    end

    if game_lobby_users.admins.length == 0
      if (admin = game_lobby_users.first)
        admin.update_attributes admin: true
        broadcast admin
      end
    end

    if game_lobby_users.length == 0
      self.delete
      broadcast self
    end
  end

  def current_game
    games.last
  end

  def has_password?
    password.present?
  end

  def has_user?(user)
    game_lobby_users.exists?(user: user)
  end

  private

  def broadcast(object)
    GameLobbyChannel.broadcast_to self, object if self.persisted?
  end
end
