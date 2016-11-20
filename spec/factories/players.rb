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

FactoryGirl.define do
  factory :player do
    game
    user { build :user, :with_expansions }

    trait :with_hand do
      after :build do |player|
        player.cards << build_list(:fool, 5)
        player.cards << build_list(:crisis, 5)
        player.cards << build_list(:bad_decision, 5)
      end
    end

    trait :with_discarded do
      after :build do |player|
        player.player_cards << build_list(:player_card, 10, :discarded)
      end
    end
  end
end
