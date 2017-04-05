# == Schema Information
#
# Table name: expansions
#
#  id         :integer          not null, primary key
#  name       :string
#  uuid       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :expansion do
    name { Faker::Hacker.say_something_smart }

    trait :with_cards do
      transient do
        story_count 2
        card_count 1
      end

      after :build do |expansion, evaluator|
        expansion.cards << build_list(:story, evaluator.story_count, expansion: expansion)
        expansion.cards << build_list(:fool, evaluator.card_count, expansion: expansion)
        expansion.cards << build_list(:crisis, evaluator.card_count, expansion: expansion)
        expansion.cards << build_list(:bad_decision, evaluator.card_count, expansion: expansion)
      end
    end
  end
end
