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
#

class GameLobbyUser < ApplicationRecord
  belongs_to :game_lobby
  belongs_to :user

  acts_as_paranoid

  validates_presence_of :game_lobby
  validates_presence_of :user
end
