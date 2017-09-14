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

  def join(user=nil, password=nil)
    raise Exceptions::LobbyClosedViolation.new if deleted?

    if has_password?
      raise Exceptions::LobbyPermissionViolation.new if password != self.password
    end

    lobby_user = nil

    if user.present? and has_user? user
      lobby_user = lobby_users.find_by(user: user)
    end

    if lobby_user.nil?
      lobby_user = LobbyUser.new(user: user, admin: lobby_users.empty?, lobby: self)
      self.lobby_users << lobby_user
    end

    save
    lobby_user.save!
    lobby_user.broadcast!
    lobby_user
  end

  def leave(user_or_id)
    raise Exceptions::LobbyClosedViolation.new if deleted?

    if user_or_id.is_a? LobbyUser
      lobby_user = user_or_id
    elsif user_or_id.is_a? String
      lobby_user = lobby_users.find_by(guid: user_or_id)
    else
      lobby_user = lobby_users.find_by(user: user_or_id)
    end

    return false unless lobby_user

    if self.current_game&.has_lobby_user?(lobby_user)
      current_game.leave(lobby_user)
    end

    lobby_user.destroy

    if lobby_users.admins.length == 0
      if (admin = lobby_users.first)
        admin.update_attributes admin: true
        admin.broadcast!
      end
    end

    if lobby_users.count == 0
      self.destroy
      self.broadcast!
    end

    lobby_user.broadcast!
  end

  def new_game
    if true || current_game.nil? || current_game.finished?
      game = Game.create(lobby: self, score_limit: 13)
      game.broadcast!
      game
    else
      raise Exceptions::GameStatusViolation.new 'Please finish the current game before starting a new one!'
    end
  end

  def current_game
    games.last
  end

  def has_password?
    password.present?
  end

  def has_user?(user_or_id, options={})
    scope = lobby_users
    scope = scope.with_deleted if options[:necromancy]

    if user_or_id.is_a? String
      scope.exists?(guid: user_or_id)
    else
      scope.exists?(user: user_or_id)
    end
  end

  def broadcast!
    self.broadcast LobbySerializer.new(self).as_json
  end

  def broadcast(data)
    LobbyChannel.broadcast_to self, data if self.persisted?
  end

  def slash_command(command, data=nil)
    case command
      when 'skip'
        current_game.next_round
      when 'reset'
        new_game
      when 'draw'
        current_game.players.collect(&:draw!)
      else
        false
    end
  end
end
