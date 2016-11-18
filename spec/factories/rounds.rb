# == Schema Information
#
# Table name: rounds
#
#  id                :integer          not null, primary key
#  game_id           :integer
#  number            :integer
#  bard_player_id    :integer
#  winning_player_id :integer
#  first_pc_id       :integer
#  second_pc_id      :integer
#  third_pc_id       :integer
#  story_card_id     :integer
#  status            :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

FactoryGirl.define do
  factory :round do
    game { build :game, :with_player_cards }
    bard_player { game.players.first }

    trait :setup do
      status 'setup'
      association :story_card, factory: :story
    end

    trait :player_pick do
      status 'player_pick'
      first_pc { bard_player.player_cards.first }
      second_pc { bard_player.player_cards.last }
    end

    trait :bard_pick do
      player_pick
      status 'bard_pick'
      player_cards { game.players.collect { |p| p.player_cards.first } }
    end

    trait :finished do
      bard_pick
      status 'finished'

      third_pc { player_cards.last }
      winning_player { third_pc.player }
    end

    trait :without_submissions do
      player_cards { [] }
    end
  end
end
