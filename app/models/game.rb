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

  MIN_PLAYERS = Rails.env.production? ? 2 : 1

  belongs_to :lobby
  belongs_to :winning_user, class_name: LobbyUser
  has_many :players, autosave: true
  has_many :player_cards, through: :players
  has_many :rounds
  has_and_belongs_to_many :expansions, join_table: :game_expansions
  has_many :cards, through: :expansions

  has_guid

  validates_presence_of :lobby

  after_create :assign_default_expansions

  state_machine :status, initial: :starting do
    after_transition any => any, do: [:broadcast!]
    after_transition :starting => :in_progress, do: [:start_first_round]
    after_transition any => :abandoned, do: [:abandoned_game]
    before_transition :in_progress => :finished, do: [:assign_winner]

    state :in_progress do
      validate :validate_player_count
    end

    state :finished do
      validates_presence_of :winning_user
    end

    state :abandoned

    event :start do
      transition :starting => :in_progress
    end

    event :finish do
      transition :in_progress => :finished
    end

    event :abandon do
      transition any => :abandoned
    end
  end

  def player_for(lobby_user)
    players.find_by! lobby_user: lobby_user
  end

  def join(lobby_user)
    raise Exceptions::UserLobbyViolation.new I18n.t('violations.user_lobby') unless lobby_user.lobby == self.lobby
    raise Exceptions::GameStatusViolation.new I18n.t('violations.game_status') unless self.starting?
    raise Exceptions::PlayerExistsViolation.new I18n.t('violations.player_exists') if self.players.exists?(lobby_user: lobby_user)

    player = Player.new(lobby_user: lobby_user, game: self)
    self.players << player
    player.broadcast!

    self.save
    player
  end

  def leave(lobby_user)
    raise Exceptions::UserLobbyViolation.new I18n.t('violations.user_lobby') unless lobby_user.lobby == self.lobby
    raise Exceptions::PlayerExistsViolation.new I18n.t('violations.not_player_exists') unless has_lobby_user?(lobby_user)

    player = self.players.find_by!(lobby_user: lobby_user)
    self.players.delete(player)
    player.broadcast!

    if self.players.length < MIN_PLAYERS
      self.rounds.any? ? self.finish : self.abandon
    else
      true
    end
  end

  def current_round
    self.rounds.last
  end

  def next_round
    raise Exceptions::GameStatusViolation.new I18n.t('violations.game_status') unless self.in_progress?
    raise Exceptions::RoundOrderViolation.new I18n.t('violations.round_order') unless self.rounds.empty? || self.rounds.last.finished?

    if self.rounds.count < self.score_limit
      bard   = self.players.where('players.id > ?', self.current_round&.bard_player&.id || 0).first
      bard ||= self.players.first

      new_round = self.rounds.build(bard_player: bard)
      new_round.draw!
    else
      self.finish!
      new_round = nil
    end

    new_round&.broadcast!
    self.broadcast!
    new_round
  end

  def ready?
    self.starting? and self.players.count >= MIN_PLAYERS
  end

  def has_lobby_user?(lobby_user)
    self.players.exists?(lobby_user: lobby_user)
  end

  def broadcast!
    self.lobby.broadcast game: GameSerializer.new(self).as_json
  end

  private

  def assign_winner
    winning_player = self.players.order(:score).first
    self.winning_user = winning_player.try :lobby_user
    self.lobby.broadcast player: winning_player
  end

  def validate_player_count
    if self.players.length < MIN_PLAYERS
      self.errors[:players] << "minimum #{MIN_PLAYERS} players"
      false
    end
    true
  end

  def start_first_round
    self.next_round
  end

  def assign_default_expansions
    self.expansions << Expansion.default
  end

  def abandoned_game
    raise "ABANDONED"
  end
end
