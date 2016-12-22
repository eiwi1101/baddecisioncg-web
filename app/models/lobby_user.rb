# == Schema Information
#
# Table name: lobby_users
#
#  id         :integer          not null, primary key
#  lobby_id   :integer
#  user_id    :integer
#  moderator  :boolean
#  admin      :boolean
#  deleted_at :datetime
#  guid       :string
#  name       :string
#

class LobbyUser < ApplicationRecord
  include HasGuid

  belongs_to :lobby
  belongs_to :user
  has_many :players

  acts_as_paranoid
  has_guid

  validates_presence_of :lobby

  before_validation :generate_guest_name

  scope :admins, -> { where(admin: true) }

  def name
    super || user&.display_name
  end

  def avatar_url
    color = Digest::MD5.hexdigest(self.name)[-6,6]
    letter = name.match(/\S\s*(\S)/)[0]
    user&.avatar_url || "https://placehold.it/80/#{color}/fff?text=#{letter}"
  end

  def guest?
    self.user.nil?
  end

  def leave!
    self.lobby&.leave self.user
  end

  def broadcast!
    self.lobby.broadcast user: LobbyUserSerializer.new(self).as_json
  end

  def broadcast(data)
    Rails.logger.debug "Broadcasting to lobby user #{self.guid}: #{data.inspect}"
    LobbyUserChannel.broadcast_to self, data if self.persisted?
  end

  private

  def generate_guest_name
    self.name = "Anonymous " + Faker::Team.creature.singularize.humanize if self.guest?
  end
end
