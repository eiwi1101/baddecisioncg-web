class CardSerializer < ActiveModel::Serializer
  attributes :guid
  attribute :to_html, key: :html
end
