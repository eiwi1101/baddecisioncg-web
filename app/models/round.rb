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
#  guid               :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class Round < ApplicationRecord
  include HasGuid

  belongs_to :game
  belongs_to :bard_player, class_name: Player
  belongs_to :winning_player, class_name: Player, counter_cache: :score
  belongs_to :fool_pc, class_name: PlayerCard
  belongs_to :crisis_pc, class_name: PlayerCard
  belongs_to :bad_decision_pc, class_name: PlayerCard
  belongs_to :story_card, class_name: Card::Story
  has_many :player_cards, autosave: true
  has_one  :lobby, through: :game

  has_guid

  validates_presence_of :game
  validates_presence_of :bard_player

  state_machine :status, initial: nil do
    after_transition any => any, do: [:broadcast!]

    before_transition nil => :setup, do: [:draw_story, :players_draw]
    before_transition any => :finished, do: [:mark_winner]

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

  def play(player, player_card)
    player.bard? ? bard_play(player_card) : player_play(player_card)
  end

  def bard_play(player_card)
    raise Exceptions::DiscardedCardViolation.new if player_card.discarded?
    raise Exceptions::PlayerHandViolation.new if player_card.player != self.bard_player
    raise Exceptions::RoundOrderViolation.new unless self.setup?
    raise Exceptions::CardTypeViolation.new I18n.t('violations.card_type') if self.story_card.card_order.last == player_card.card.type_string

    if (slot = self.send(player_card.card.type_string + '_pc'))
      slot.update_attributes(round: nil)
    end

    player_card.update_attributes(round: self)
    self.update_attributes(player_card.card.type_string + '_pc' => player_card)
    self.bard_in? ? self.reveal! : self.broadcast!
    true
  end

  def player_play(player_card)
    raise Exceptions::DiscardedCardViolation.new if player_card.discarded?
    raise Exceptions::PlayerHandViolation.new if player_card.player == self.bard_player
    raise Exceptions::RoundOrderViolation.new unless self.player_pick?
    raise Exceptions::CardTypeViolation.new I18n.t('violations.card_type') unless self.story_card.card_order.last == player_card.card.type_string

    if (slot = self.player_cards.where(player: player_card.player)).any?
      slot.each { |pc| pc.update_attributes(round: nil) }
    end

    player_card.update_attributes(round: self)
    self.player_cards << player_card
    self.all_in? ? self.all_in! : self.broadcast!
    true
  end

  def bard_pick(player, player_card)
    raise Exceptions::PlayerRoleViolation.new I18n.t('violations.player_role') unless player.bard?
    raise Exceptions::RoundMismatchViolation.new unless player_card.round == self
    raise Exceptions::CardTypeViolation.new I18n.t('violations.card_type') unless self.story_card.card_order.last == player_card.card.type_string
    raise Exceptions::RoundOrderViolation.new unless self.bard_pick?

    self.update_attributes(player_card.card.type_string + '_pc' => player_card)
    self.finish!
    true
  end

  def story_text
    self.story_card&.display_text self
  end

  def story_html
    self.story_card&.to_html self
  end

  def submitted_player_cards
    return nil unless self.story_card
    self.player_cards.send(blank_scope)
  end

  def all_in?
    submitted_player_cards.length == self.game.players.length - 1
  end

  def bard_in?
    !(self.card_blanks.first.nil? || self.card_blanks.second.nil?)
  end

  def bard_picked?
    !self.card_blanks.last.nil?
  end

  def card_blanks
    return [] if self.story_card.nil?

    self.story_order.collect do |type|
      self.send(type + '_pc')
    end
  end

  def story_order
    self.story_card&.card_order
  end

  def broadcast!
    self.lobby.broadcast round: RoundSerializer.new(self).as_json if self.lobby
  end

  private

  def blank_scope
    return nil unless story_card
    case story_order.last
      when 'crisis'
        'crisis'
      else
        story_order.last.pluralize
    end
  end

  def draw_story
    self.story_card = Card::Story.in_hand_for_game(self.game).random
    self.broadcast!
  end

  def players_draw
    self.game.players.collect(&:draw!)
  end

  def mark_winner
    self.winning_player = self.card_blanks.last.player if self.bard_picked?
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
