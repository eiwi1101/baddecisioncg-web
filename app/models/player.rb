# == Schema Information
#
# Table name: players
#
#  id      :integer          not null, primary key
#  game_id :integer
#  user_id :integer
#  score   :integer
#  order   :integer
#

class Player < ApplicationRecord
  belongs_to :user
  belongs_to :game
  has_many :player_cards
  has_many :cards, through: :player_cards

  validates_presence_of :user
  validates_presence_of :game
end
