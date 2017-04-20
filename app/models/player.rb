# == Schema Information
#
# Table name: players
#
#  id            :integer          not null, primary key
#  game_id       :integer
#  lobby_user_id :integer
#  score         :integer
#  order         :integer
#  guid          :string
#  deleted_at    :datetime
#

class Player < ApplicationRecord
  include HasGuid

  belongs_to :lobby_user
  belongs_to :game
  has_one :lobby, through: :game
  has_one :user, through: :lobby_user
  has_many :player_cards
  has_many :cards, through: :player_cards
  has_many :expansions, through: :user

  has_guid
  acts_as_paranoid

  validates_presence_of :lobby_user
  validates_presence_of :game
  
  after_restore { self.broadcast! }

  def current_round
    self.game&.current_round
  end

  def bard?
    game&.current_round&.bard_player == self
  end

  def draw(card)
    player_cards << PlayerCard.new(card: card, player: self)
  end

  def draw!
    @defer_broadcast = true
    Card.fools.in_hand_for_game(game).random([5 - player_cards.fools.in_hand.count, 0].max).each { |c| draw c }
    Card.crisis.in_hand_for_game(game).random([5 - player_cards.crisis.in_hand.count, 0].max).each { |c| draw c }
    Card.bad_decisions.in_hand_for_game(game).random([5 - player_cards.bad_decisions.in_hand.count, 0].max).each { |c| draw c }
    @defer_broadcast = false
    self.broadcast!
  end

  def broadcast!
    return if @defer_broadcast
    lobby.broadcast player: PlayerSerializer.new(self).as_json if self.lobby
    lobby_user.broadcast player: PrivatePlayerSerializer.new(self).as_json if self.lobby_user
  end
end
