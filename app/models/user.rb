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

class User < ApplicationRecord
  include HasGuid

  has_and_belongs_to_many :expansions,
                          join_table: :user_expansions

  has_and_belongs_to_many :friends,
                          class_name: User,
                          join_table: :friendships,
                          foreign_key: :user_id,
                          association_foreign_key: :friend_user_id

  has_guid :uuid, type: :uuid

  validates_presence_of :username
  validates_presence_of :email
  validates_presence_of :display_name
  validates_uniqueness_of :username
  validates_uniqueness_of :email

  has_secure_password
end
