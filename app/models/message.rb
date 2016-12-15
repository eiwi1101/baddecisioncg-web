# == Schema Information
#
# Table name: messages
#
#  id         :integer          not null, primary key
#  lobby_id   :integer
#  user_id    :integer
#  message    :text
#  guid       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Message < ApplicationRecord
  include HasGuid

  belongs_to :lobby
  belongs_to :lobby_user, -> { with_deleted }, foreign_key: :user_id
  has_one :user, through: :lobby_user

  has_guid

  validates_presence_of :lobby
  validates_presence_of :lobby_user
  validates_presence_of :message

  after_commit do
    self.lobby.broadcast message: self.as_json
  end
end
