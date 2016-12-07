# == Schema Information
#
# Table name: messages
#
#  id            :integer          not null, primary key
#  game_lobby_id :integer
#  user_id       :integer
#  message       :text
#  guid          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Message < ApplicationRecord
  belongs_to :lobby
  belongs_to :user

  validates_presence_of :lobby
  validates_presence_of :user
  validates_presence_of :message
end
