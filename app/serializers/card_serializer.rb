class CardSerializer < ActiveModel::Serializer
  attributes :uuid,
             :text

  attribute :to_html, key: :html
end
