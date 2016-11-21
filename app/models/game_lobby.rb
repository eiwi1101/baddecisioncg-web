# == Schema Information
#
# Table name: game_lobbies
#
#  id         :integer          not null, primary key
#  name       :string
#  private    :boolean
#  token      :string
#  password   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class GameLobby < ApplicationRecord
  has_many :games
  has_many :game_lobby_users
  has_many :users, through: :game_lobby_users
  has_many :messages

  validates_presence_of :name
end