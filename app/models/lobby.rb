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

class Lobby < ApplicationRecord
  include HasGuid

  has_many :games
  has_many :lobby_users
  has_many :users, through: :lobby_users
  has_many :messages

  has_guid :token, type: :token
  acts_as_paranoid

  validates_presence_of :name

  scope :for_user, -> (user) { joins(:lobby_users).where('lobby_users.user' => user) }

  def join(user, password=nil)
    raise Exceptions::LobbyClosedViolation.new if deleted?

    if has_password?
      raise Exceptions::LobbyPermissionViolation.new if password != self.password
    end

    if user.nil?
      lobby_user = LobbyUser.new(admin: lobby_users.empty?)
      lobby_users << lobby_user
    elsif has_user? user
        lobby_user = lobby_users.find_by(user: user)
    else
      lobby_user = LobbyUser.new(user: user, admin: lobby_users.empty?)
      lobby_users << lobby_user
    end

    broadcast user_joined: lobby_user.as_json
    lobby_user
  end

  def leave(user)
    raise Exceptions::LobbyClosedViolation.new if deleted?

    lobby_user = lobby_users.find_by!(user: user)
    lobby_users.delete(lobby_user)

    if current_game&.has_lobby_user?(lobby_user)
      current_game.leave(lobby_user)
      broadcast user_left: lobby_user.as_json
    end

    if lobby_users.admins.length == 0
      if (admin = lobby_users.first)
        admin.update_attributes admin: true
        broadcast user_is_admin: admin.as_json
      end
    end

    if lobby_users.length == 0
      self.delete
      broadcast lobby_closed: self.as_json
    end
  end

  def current_game
    games.last
  end

  def has_password?
    password.present?
  end

  def has_user?(user)
    lobby_users.exists?(user: user)
  end

  def as_json
    ActiveModelSerializers::SerializableResource.new(self).as_json
  end

  def broadcast(data)
    LobbyChannel.broadcast_to self, data if self.persisted?
  end
end
