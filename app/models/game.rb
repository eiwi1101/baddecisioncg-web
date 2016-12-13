# == Schema Information
#
# Table name: games
#
#  id              :integer          not null, primary key
#  score_limit     :integer
#  lobby_id        :integer
#  winning_user_id :integer
#  status          :string
#  guid            :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Game < ApplicationRecord
  include HasGuid

  belongs_to :lobby
  belongs_to :winning_user, class_name: LobbyUser
  has_many :players, autosave: true
  has_many :rounds
  has_and_belongs_to_many :expansions, join_table: :game_expansions
  has_many :cards, through: :expansions

  has_guid

  validates_presence_of :lobby

  after_create :assign_default_expansions

  state_machine :status, initial: nil do
    after_transition nil => :in_progress, do: [:broadcast_game_start, :start_first_round]
    before_transition :in_progress => :finished, do: [:assign_winner]
    after_transition :in_progress => :finished, do: [:broadcast_game_finished]

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
    raise Exceptions::PlayerExistsViolation.new if self.players.exists?(lobby_user: lobby_user)

    player = Player.new(lobby_user: lobby_user, game: self)
    self.players << player
    self.lobby.broadcast player_join: player.as_json
    self.save
  end

  def leave(lobby_user)
    raise Exceptions::UserLobbyViolation.new unless lobby_user.lobby == self.lobby
    raise Exceptions::PlayerExistsViolation.new unless has_lobby_user?(lobby_user)

    player = self.players.find_by!(lobby_user: lobby_user)
    self.players.delete(player)

    self.lobby.broadcast player_leave: player.as_json

    if self.players.length < 2
      self.rounds.any? ? self.finish : self.abandon
    else
      true
    end
  end

  def current_round
    self.rounds.last
  end

  def next_round
    raise Exceptions::GameStatusViolation.new("Invalid with current game status: #{self.status}") unless self.in_progress?
    raise Exceptions::RoundOrderViolation.new("Invalid with current round status: #{self.current_round&.status}") unless self.rounds.empty? || self.rounds.last.finished?

    if self.rounds.count < self.score_limit
      bard   = self.players.where('players.id > ?', self.current_round&.bard_player&.id || 0).first
      bard ||= self.players.first

      new_round = self.rounds.build(bard_player: bard)
      new_round.draw!
    else
      self.finish!
      new_round = nil
    end

    self.lobby.broadcast next_round: new_round.as_json if new_round
    new_round
  end

  def has_lobby_user?(lobby_user)
    self.players.exists?(lobby_user: lobby_user)
  end

  private

  def assign_winner
    winning_player = self.players.order(:score).first
    self.winning_user = winning_player.try :lobby_user
    self.lobby.broadcast player_won: winning_player
  end

  def validate_player_count
    if self.players.length < 2
      self.errors[:players] << 'minimum 2 players'
      false
    end
    true
  end

  def broadcast_game_start
    self.lobby.broadcast game_start: self.as_json
  end

  def broadcast_game_finished
    self.lobby.broadcast game_finished: self.as_json
  end

  def start_first_round
    self.next_round
  end

  def assign_default_expansions
    self.expansions << Expansion.default
  end
end
