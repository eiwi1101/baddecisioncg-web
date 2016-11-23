# == Schema Information
#
# Table name: games
#
#  id              :integer          not null, primary key
#  score_limit     :integer
#  game_lobby_id   :integer
#  winning_user_id :integer
#  status          :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Game < ApplicationRecord
  belongs_to :game_lobby
  belongs_to :winning_user, class_name: User
  has_many :players, autosave: true
  has_many :rounds
  has_many :expansions, through: :players
  has_many :cards, through: :expansions

  validates_presence_of :game_lobby

  state_machine :status, initial: nil do
    before_transition :in_progress => :finished, do: [:assign_winner]

    state :in_progress do
      validate :validate_player_count
    end

    state :finished do
      validates_presence_of :winning_user
    end

    event :start do
      transition nil => :in_progress
    end

    event :finish do
      transition :in_progress => :finished
    end
  end

  def join(game_lobby_user)
    raise Exceptions::UserLobbyViolation.new unless game_lobby_user.game_lobby == self.game_lobby
    raise Exceptions::GameStatusViolation.new unless self.status.nil?
    raise Exceptions::PlayerExistsViolation.new if self.players.exists?(user: game_lobby_user.user)

    self.players << Player.new(user: game_lobby_user.user)
    self.save
  end

  def remove(game_lobby_user)
    raise Exceptions::UserLobbyViolation.new unless game_lobby_user.game_lobby == self.game_lobby
    raise Exceptions::PlayerExistsViolation.new unless self.players.exists?(user: game_lobby_user.user)

    player = self.players.find_by(user: game_lobby_user.user)
    self.players.delete(player)

    if self.players.length < 2
      self.finish
    else
      true
    end
  end

  private

  def assign_winner
    self.winning_user = self.players.order(:score).first.try :user
  end

  def validate_player_count
    if self.players.length < 2
      self.errors[:players] << 'minimum 2 players'
      false
    end
    true
  end
end
