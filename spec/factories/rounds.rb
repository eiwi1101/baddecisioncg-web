# == Schema Information
#
# Table name: rounds
#
#  id                 :integer          not null, primary key
#  game_id            :integer
#  number             :integer
#  bard_player_id     :integer
#  winning_player_id  :integer
#  fool_pc_id         :integer
#  crisis_pc_id       :integer
#  bad_decision_pc_id :integer
#  story_card_id      :integer
#  status             :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

FactoryGirl.define do
  factory :round do
    game { build :game, :with_player_cards }
    bard_player { game.players.first }

    trait :setup do
      status 'setup'
      association :story_card, factory: :story
    end

    trait :bard_in do
      fool_pc { build :player_card, player: bard_player, card: build(:fool) }
      crisis_pc { build :player_card, player: bard_player, card: build(:crisis) }
    end

    trait :player_pick do
      setup
      bard_in
      status 'player_pick'
    end

    trait :players_in do
      player_cards { game.players.collect { |p| p.player_cards.first } }
    end

    trait :bard_pick do
      player_pick
      players_in
      status 'bard_pick'
    end

    trait :finished do
      bard_pick
      status 'finished'

      bad_decision_pc { player_cards.last }
      winning_player { bad_decision_pc.player }
    end

    trait :without_submissions do
      player_cards { [] }
    end
  end
end
