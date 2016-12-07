# == Schema Information
#
# Table name: game_lobby_users
#
#  id            :integer          not null, primary key
#  game_lobby_id :integer
#  user_id       :integer
#  moderator     :boolean
#  admin         :boolean
#  deleted_at    :datetime
#  guid          :string
#

class LobbyUser < ApplicationRecord
  include HasGuid

  belongs_to :lobby
  belongs_to :user

  acts_as_paranoid
  has_guid

  validates_presence_of :lobby
  validates_presence_of :user

  scope :admins, -> { where(admin: true) }

  def leave!
    self.lobby&.leave self.user
  end

  def as_json
    ActiveModelSerializers::SerializableResource.new(self).as_json
  end
end
