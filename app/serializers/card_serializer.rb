class CardSerializer < ActiveModel::Serializer
  attributes :uuid,
             :text,
             :card_order

  def card_order
    object.card_order if object.type == 'Card::Story'
  end
end
