# == Schema Information
#
# Table name: player_cards
#
#  id        :integer          not null, primary key
#  player_id :integer
#  card_id   :integer
#  round_id  :integer
#

class PlayerCard < ApplicationRecord
  belongs_to :player
  belongs_to :card, autosave: true
  belongs_to :round

  scope :fools, -> { joins(:card).where(cards: { type: 'Card::Fool' }) }
  scope :crisis, -> { joins(:card).where(cards: { type: 'Card::Crisis' }) }
  scope :bad_decisions, -> { joins(:card).where(cards: { type: 'Card::BadDecision' }) }

  scope :discarded, -> { where.not(round: nil) }
  scope :in_hand,   -> { where(round: nil) }

  def discarded?
    !round.nil?
  end
end
