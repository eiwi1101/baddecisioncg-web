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

  scope :for_game, -> (game) { game.cards.stories }
  scope :discarded_for_game, -> (game) { for_game(game).where(id: game.rounds.select(:story_card_id)) }
  scope :in_hand_for_game,   -> (game) { for_game(game).where.not(id: game.rounds.select(:story_card_id)) }
end
