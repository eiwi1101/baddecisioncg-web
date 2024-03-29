class PlayerCardSerializer < ActiveModel::Serializer
  attributes :id,
             :card_id,
             :type,
             :text,
             :is_discarded,
             :path

  def id
    object.guid
  end

  def card_id
    object.card.uuid
  end

  def text
    object.card.display_text(object.round)
  end

  def is_discarded
    object.discarded?
  end

  def path
    "/cards/#{object.guid}"
  end
end
