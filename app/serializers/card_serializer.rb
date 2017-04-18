class CardSerializer < ActiveModel::Serializer
  attributes :uuid
  attribute :to_html, key: :html
end
