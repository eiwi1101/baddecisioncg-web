class UserSerializer < ActiveModel::Serializer
  attributes :uuid, :display_name, :username, :avatar_url, :admin
end
