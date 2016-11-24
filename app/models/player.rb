# == Schema Information
#
# Table name: players
#
#  id         :integer          not null, primary key
#  game_id    :integer
#  user_id    :integer
#  score      :integer
#  order      :integer
#  guid       :string
#  deleted_at :datetime
#

class Player < ApplicationRecord
  include HasGuid

  belongs_to :user
  belongs_to :game
  has_many :player_cards
  has_many :cards, through: :player_cards
  has_many :expansions, through: :user

  has_guid
  act_as_paranoid

  validates_presence_of :user
  validates_presence_of :game
end
