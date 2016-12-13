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
  belongs_to :user

  has_guid

  validates_presence_of :lobby
  validates_presence_of :user
  validates_presence_of :message

  # TODO : Make this the proper assoc.
  def lobby_user
    lobby.lobby_users.find_by(user: user)
  end

  after_commit do
    self.lobby.broadcast message: self.as_json
  end
end
