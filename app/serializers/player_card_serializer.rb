class PlayerCardSerializer < ActiveModel::Serializer
  attributes :guid, :type, :text, :is_discarded

  def type
    object.card.type_string
  end

  def text
    object.card.display_text(object.round)
  end

  def is_discarded
    object.discarded?
  end
end
