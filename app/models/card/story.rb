# == Schema Information
#
# Table name: cards
#
#  id           :integer          not null, primary key
#  type         :string
#  text         :text
#  expansion_id :integer
#

class Card::Story < Card
  has_many :rounds, foreign_key: :story_card_id

  validate :validate_placeholder_text

  scope :for_game, -> (game) { game.cards.stories }
  scope :discarded_for_game, -> (game) { for_game(game).where(id: game.rounds.select(:story_card_id)) }
  scope :in_hand_for_game,   -> (game) { for_game(game).where.not('EXISTS (?)', game.rounds.select(nil).where('rounds.story_card_id = cards.id')) }

  def card_order
    order = []
    Rails.logger.info "TEXT: #{text}"
    text.scan(/%{(\w+)}/i) do |match|
      order << match[0]
    end
    Rails.logger.info "MATCH: #{order}"
    order
  end

  def display_text(round)
    # round.includes(fool_pc: [:card], crisis_pc: [:card], bad_decision_pc: [:card])
    blanks = {
        fool: round.fool_pc.try(:card).try(:text) || 'FOOL',
        crisis: round.crisis_pc.try(:card).try(:text) || 'CRISIS',
        bad_decision: round.bad_decision_pc.try(:card).try(:text) || 'BAD DECISION'
    }

    text % blanks
  end

  private

  def validate_placeholder_text
    if self.card_order.uniq.sort != ['bad_decision', 'crisis', 'fool']
      self.errors[:text] << 'has invalid placeholders'
      false
    end
    true
  end
end
