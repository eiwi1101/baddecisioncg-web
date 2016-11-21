# == Schema Information
#
# Table name: rounds
#
#  id                 :integer          not null, primary key
#  game_id            :integer
#  number             :integer
#  bard_player_id     :integer
#  winning_player_id  :integer
#  fool_pc_id         :integer
#  crisis_pc_id       :integer
#  bad_decision_pc_id :integer
#  story_card_id      :integer
#  status             :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class Round < ApplicationRecord
  belongs_to :game
  belongs_to :bard_player, class_name: Player
  belongs_to :winning_player, class_name: Player
  belongs_to :fool_pc, class_name: PlayerCard
  belongs_to :crisis_pc, class_name: PlayerCard
  belongs_to :bad_decision_pc, class_name: PlayerCard
  belongs_to :story_card, class_name: Card::Story
  has_many :player_cards

  validates_presence_of :game
  validates_presence_of :bard_player

  state_machine :status, initial: nil do
    before_transition nil => :setup, do: [:draw_story]

    state :setup do
      validates_presence_of :story_card
    end

    state :player_pick do
      validate :validate_bard_submitted
    end

    state :bard_pick do
      validate :validate_all_players_submitted
    end

    state :finished do
      validate :validate_bard_picked
      validates_presence_of :winning_player
    end

    event :draw do
      transition nil => :setup
    end

    event :reveal do
      transition :setup => :player_pick
    end

    event :all_in do
      transition :player_pick => :bard_pick
    end

    event :finish do
      transition :bard_pick => :finished
    end
  end

  def bard_play(player_card)
    raise Exceptions::DiscardedCardViolation.new if player_card.discarded?
    raise Exceptions::PlayerHandViolation.new if player_card.player != self.bard_player
    raise Exceptions::RoundOrderViolation.new unless self.setup?
    raise Exceptions::CardTypeViolation.new if self.story_card.card_order.last == player_card.card.type_string

    slot = self.send(player_card.card.type_string + '_pc')
    slot.try(:update_attributes, round: nil)

    player_card.assign_attributes(round: self)
    self.assign_attributes(player_card.card.type_string + '_pc' => player_card)
    true
  end

  def player_play(player_card)
    raise Exceptions::DiscardedCardViolation.new if player_card.discarded?
    raise Exceptions::PlayerHandViolation.new if player_card.player == self.bard_player
    raise Exceptions::RoundOrderViolation.new unless self.player_pick?
    raise Exceptions::CardTypeViolation.new unless self.story_card.card_order.last == player_card.card.type_string

    slot = self.player_cards.where(player: player_card.player)
    slot.try(:update_attributes, round: nil)

    self.player_cards << player_card
    true
  end

  def story_text
    self.story_card.try(:display_text, self)
  end

  def all_in?
    self.player_cards.length == self.game.players.length
  end

  def bard_in?
    !(self.card_blanks.first.nil? || self.card_blanks.second.nil?)
  end

  def bard_picked?
    !self.card_blanks.third.nil?
  end

  def card_blanks
    raise Exceptions::RoundOrderViolation.new if self.story_card.nil?

    self.story_order.collect do |type|
      self.send(type + '_pc')
    end
  end

  def story_order
    self.story_card.card_order
  end

  private

  def draw_story
    self.story_card = Card::Story.in_hand_for_game(self.game).order('RANDOM()').limit(1).first
  end

  def validate_all_players_submitted
    self.errors[:player_cards] << 'must be submitted from all players' unless self.all_in?
    self.all_in?
  end

  def validate_bard_submitted
    self.errors[story_order.first  + '_pc'] << "can't be blank" if card_blanks.first.nil?
    self.errors[story_order.second + '_pc'] << "can't be blank" if card_blanks.second.nil?
    self.bard_in?
  end

  def validate_bard_picked
    self.errors[story_order.third + '_pc'] << "can't be blank" if card_blanks.third.nil?
    self.bard_picked?
  end
end
