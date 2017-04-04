# == Schema Information
#
# Table name: games
#
#  id              :integer          not null, primary key
#  score_limit     :integer
#  lobby_id        :integer
#  winning_user_id :integer
#  status          :string
#  guid            :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class GameSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id,
             :score_limit,
             :status,
             :isReady,
             :path

  has_one  :current_round, serializer: RoundSerializer
  has_many :players, serializer: PlayerSerializer

  def id
    object.guid
  end

  def isReady
    object.ready?
  end

  def path
    game_path object
  end
end
