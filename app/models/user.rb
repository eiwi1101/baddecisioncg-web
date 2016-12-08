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

  has_many :lobby_users
  has_many :lobbies, through: :lobby_users

  has_guid :uuid, type: :uuid

  validates_presence_of :username
  validates_presence_of :email
  validates_presence_of :display_name
  validates_uniqueness_of :username, case_sensitive: false
  validates_uniqueness_of :email, case_sensitive: false

  validates_format_of :username, with: /\A[^_-].*[^_-]\z/, message: 'can not start or end with _ or -'
  validates_format_of :username, with: /\A[a-z0-9][a-z0-9_-]+[a-z0-9]\z/i, message: 'can only be letters, numbers, _ and -'
  validates_format_of :email, with: /@/, message: 'must have an @ sign'

  has_secure_password

  scope :admins, -> { where(admin: true) }

  def avatar_url
    GravatarImageTag.gravatar_url self.email
  end

  def online!
    Rails.logger.info "Online: #{self.username}"

    self.friends.find_each do |friend|
      friend.broadcast online: self.as_json
    end
  end

  def offline!
    Rails.logger.info "Offline: #{self.username}"

    self.friends.find_each do |friend|
      friend.broadcast offline: self.as_json
    end
  end

  def as_json
    ActiveModelSerializers::SerializableResource.new(self).as_json
  end

  def broadcast(data)
    UserChannel.broadcast_to self, data
  end
end
