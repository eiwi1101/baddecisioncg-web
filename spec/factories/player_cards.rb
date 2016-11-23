# == Schema Information
#
# Table name: player_cards
#
#  id        :integer          not null, primary key
#  player_id :integer
#  card_id   :integer
#  round_id  :integer
#  guid      :string
#

FactoryGirl.define do
  factory :player_card do
    player
    card { build :card, text: card_text }

    transient do
      card_text { Faker::Lorem.sentence }
    end

    trait :discarded do
      round
    end
  end
end
