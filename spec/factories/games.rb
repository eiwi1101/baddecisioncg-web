# == Schema Information
#
# Table name: games
#
#  id              :integer          not null, primary key
#  score_limit     :integer
#  game_lobby_id   :integer
#  winning_user_id :integer
#  status          :string
#  guid            :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

FactoryGirl.define do
  factory :game do
    score_limit 13
    game_lobby

    trait :with_players do
      game_lobby { build :game_lobby, :with_users, user_attributes: [] }

      after :build do |game|
        game.players << game.game_lobby.users.collect { |u| build :player, user: u, game: game }
      end
    end

    trait :with_player_cards do
      game_lobby { build :game_lobby, :with_users }

      after :build do |game|
        game.players.delete_all
        game.players << game.game_lobby.users.collect { |u| build :player, :with_hand, user: u, game: game }
      end
    end

    trait :short do
      score_limit 1
    end

    trait :infinite do
      score_limit nil
    end

    trait :in_progress do
      with_players
      status 'in_progress'
    end

    trait :finished do
      with_players
      status 'finished'

      after :build do |game|
        game.winning_user = game.players.first.user
      end
    end
  end
end
