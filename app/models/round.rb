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
      validates_presence_of :fool_pc
      validates_presence_of :crisis_pc
    end

    state :bard_pick do
      validate :validate_all_players_submitted
    end

    state :finished do
      validates_presence_of :bad_decision_pc
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

  def all_in?
    self.player_cards.length == self.game.players.length
  end

  private

  def draw_story
    self.story_card = Card::Story.in_hand_for_game(self.game).order('RANDOM()').limit(1).first
  end

  def validate_all_players_submitted
    unless self.all_in?
      self.errors[:player_cards] << 'must be submitted from all players'
      false
    end
    true
  end
end
