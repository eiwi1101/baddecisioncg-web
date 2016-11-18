# == Schema Information
#
# Table name: player_cards
#
#  id        :integer          not null, primary key
#  player_id :integer
#  card_id   :integer
#  round_id  :integer
#

FactoryGirl.define do
  factory :player_card do
    player
    card

    trait :discarded do
      round
    end
  end
end
