class PrivatePlayerSerializer < ActiveModel::Serializer
  attribute :bard_setup

  has_many :player_cards, serializer: PlayerCardSerializer

  def player_cards
    object.player_cards.in_hand
  end

  def bard_setup
    return nil unless object.bard?
    round = object.current_round

    {
        fool_pc: round.fool_pc && PlayerCardSerializer.new(round.fool_pc(round)).as_json,
        crisis_pc: round.crisis_pc && PlayerCardSerializer.new(round.crisis_pc(round)).as_json,
        bad_decision_pc: round.bad_decision_pc && PlayerCardSerializer.new(round.bad_decision_pc(round)).as_json
    }
  end
end
