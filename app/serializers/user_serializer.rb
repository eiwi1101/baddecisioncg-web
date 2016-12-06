# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  username        :string
#  email           :string
#  display_name    :string
#  password_digest :string
#  uuid            :string
#  admin           :boolean
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class UserSerializer < ActiveModel::Serializer
  attributes :uuid, :display_name, :username, :avatar_url, :admin
end
