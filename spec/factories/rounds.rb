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
      after :build do |round|
        round.save(validate: false)
        round.fool_pc   = build :player_card, player: round.bard_player, card: build(:fool), round: round
        round.crisis_pc = build :player_card, player: round.bard_player, card: build(:crisis), round: round
      end
    end

    trait :player_pick do
      setup
      bard_in
      status 'player_pick'
    end

    trait :players_in do
      after :build do |round|
        round.save(validate: false)

        round.game.players.each do |player|
          player.save!
          player.player_cards.collect(&:save!)

          next if player == round.bard_player

          card   = player.player_cards.select { |pc| pc.card.type == 'Card::BadDecision' }.first
          card ||= player_card.new player: player, card: create(:bad_decision)

          round.player_cards << card
        end
      end
    end

    trait :bard_pick do
      player_pick
      players_in
      status 'bard_pick'
    end

    trait :winner_picked do
      after :build do |round|
        round.bad_decision_pc = round.player_cards.select { |pc| pc.card.type == 'Card::BadDecision' }.first
      end
    end

    trait :finished do
      bard_pick
      winner_picked
      status 'finished'

      after :build do |round|
        round.winning_player = round.bad_decision_pc.player
      end
    end

    trait :without_submissions do
      after :build do |round|
        round.player_cards = round.player_cards.reject { |pc| pc.card.type == 'Card::BadDecision' }
      end
    end
  end
end
