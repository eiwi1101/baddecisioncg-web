class PrivatePlayerSerializer < ActiveModel::Serializer
  attributes :cards

  def cards
    cards = {}

    object.player_cards.each do |player_card|
      cards[player_card.guid] = PlayerCardSerializer.new(player_card).as_json
    end

    cards
  end
end
