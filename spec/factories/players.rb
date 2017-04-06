# == Schema Information
#
# Table name: players
#
#  id            :integer          not null, primary key
#  game_id       :integer
#  lobby_user_id :integer
#  score         :integer
#  order         :integer
#  guid          :string
#  deleted_at    :datetime
#

FactoryGirl.define do
  factory :player do
    game
    lobby_user

    trait :with_hand do
      transient do
        hand_size 1
      end

      after :build do |player, evaluator|
        player.player_cards << build_list(:player_card, evaluator.hand_size, card: build(:fool, expansion: player.game.expansions.first))
        player.player_cards << build_list(:player_card, evaluator.hand_size, card: build(:crisis, expansion: player.game.expansions.first))
        player.player_cards << build_list(:player_card, evaluator.hand_size, card: build(:bad_decision, expansion: player.game.expansions.first))
        player.valid?
      end
    end

    trait :with_discarded do
      game { build :game, :with_expansion }

      after :build do |player|
        player.player_cards << build_list(:player_card, 10, :discarded, card: build(:fool, expansion: player.game.expansions.first))
      end
    end
  end
end
