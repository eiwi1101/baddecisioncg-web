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

  belongs_to :lobby_user
  belongs_to :game
  has_one :lobby, through: :game
  has_one :user, through: :lobby_user
  has_many :player_cards
  has_many :cards, through: :player_cards
  has_many :expansions, through: :user

  has_guid
  acts_as_paranoid

  validates_presence_of :lobby_user
  validates_presence_of :game

  def as_json(options={})
    ActiveModelSerializers::SerializableResource.new(self).as_json(options)
  end

  def broadcast!
    self.lobby.broadcast player: self.as_json
  end
end
