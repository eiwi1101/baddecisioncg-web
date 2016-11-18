# == Schema Information
#
# Table name: rounds
#
#  id                :integer          not null, primary key
#  game_id           :integer
#  number            :integer
#  bard_player_id    :integer
#  winning_player_id :integer
#  first_pc_id       :integer
#  second_pc_id      :integer
#  third_pc_id       :integer
#  story_card_id     :integer
#  status            :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class Round < ApplicationRecord
  belongs_to :game
  belongs_to :bard_player, class_name: Player
  belongs_to :winning_player, class_name: Player
  belongs_to :first_pc, class_name: PlayerCard
  belongs_to :second_pc, class_name: PlayerCard
  belongs_to :third_pc, class_name: PlayerCard
  belongs_to :story_card, class_name: Card::Story
  has_many :player_cards

  validates_presence_of :game
  validates_presence_of :bard_player

  state_machine :status, initial: nil do
    state :setup do
      validates_presence_of :story_card
    end

    state :player_pick do
      validates_presence_of :first_pc
      validates_presence_of :second_pc
    end

    state :bard_pick do
      validate :validate_all_players_submitted
    end

    state :finished do
      validates_presence_of :third_pc
      validates_presence_of :winning_player
    end
  end

  def all_in?
    self.player_cards.length == self.game.players.length
  end

  private

  def validate_all_players_submitted
    unless self.all_in?
      self.errors[:player_cards] << 'must be submitted from all players'
      false
    end
    true
  end
end
