# == Schema Information
#
# Table name: games
#
#  id              :integer          not null, primary key
#  score_limit     :integer
#  game_lobby_id   :integer
#  winning_user_id :integer
#  status          :string
#  guid            :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Game < ApplicationRecord
  include HasGuid

  belongs_to :lobby
  belongs_to :winning_user, class_name: User
  has_many :players, autosave: true
  has_many :rounds
  has_many :expansions, through: :players
  has_many :cards, through: :expansions

  has_guid

  validates_presence_of :lobby

  state_machine :status, initial: nil do
    before_transition :in_progress => :finished, do: [:assign_winner]

    state :in_progress do
      validate :validate_player_count
    end

    state :finished do
      validates_presence_of :winning_user
    end

    state :abandoned

    event :start do
      transition nil => :in_progress
    end

    event :finish do
      transition :in_progress => :finished
    end

    event :abandon do
      transition any => :abandoned
    end
  end

  def join(lobby_user)
    raise Exceptions::UserLobbyViolation.new unless lobby_user.lobby == self.lobby
    raise Exceptions::GameStatusViolation.new unless self.status.nil?
    raise Exceptions::PlayerExistsViolation.new if self.players.exists?(user: lobby_user.user)

    self.players << Player.new(user: lobby_user.user)
    self.save
  end

  def leave(lobby_user)
    raise Exceptions::UserLobbyViolation.new unless lobby_user.lobby == self.lobby
    raise Exceptions::PlayerExistsViolation.new unless has_lobby_user?(lobby_user)

    player = self.players.find_by!(user: lobby_user.user)
    self.players.delete(player)

    if self.players.length < 2
      self.rounds.any? ? self.finish! : self.abandon!
    else
      true
    end
  end

  def current_round
    self.rounds.last
  end

  def next_round
    raise Exceptions::GameStatusViolation.new unless self.in_progress?
    raise Exceptions::RoundOrderViolation.new unless self.current_round.nil? || self.current_round.finished?

    if self.rounds.count < self.score_limit
      bard   = self.players.where('players.id > ?', self.current_round&.bard_player&.id || 0).first
      bard ||= self.players.first

      new_round = self.rounds.build(bard_player: bard)
      new_round.draw!
      new_round
    else
      self.finish!
      nil
    end
  end

  def has_lobby_user?(lobby_user)
    self.players.exists?(user: lobby_user.user)
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
