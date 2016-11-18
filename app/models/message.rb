# == Schema Information
#
# Table name: messages
#
#  id            :integer          not null, primary key
#  game_lobby_id :integer
#  user_id       :integer
#  message       :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Message < ApplicationRecord
  belongs_to :game_lobby
  belongs_to :user

  validates_presence_of :game_lobby
  validates_presence_of :user
  validates_presence_of :message
end
