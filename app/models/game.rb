# == Schema Information
#
# Table name: games
#
#  id              :integer          not null, primary key
#  score_limit     :integer
#  game_lobby_id   :integer
#  winning_user_id :integer
#  status          :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Game < ApplicationRecord
  belongs_to :game_lobby
  belongs_to :winning_user, class_name: User
  has_many :players
  has_many :rounds

  validates_presence_of :game_lobby

  state_machine :status, initial: nil do
    state :in_progress do
      # Validate that there are players?
    end

    state :finished do
      validates_presence_of :winning_user
    end
  end
end
