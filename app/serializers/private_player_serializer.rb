class PrivatePlayerSerializer < ActiveModel::Serializer
  has_many :player_cards, serializer: PlayerCardSerializer

  def player_cards
    object.player_cards.in_hand
  end
end
