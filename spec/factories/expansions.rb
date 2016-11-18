# == Schema Information
#
# Table name: expansions
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :expansion do
    name { Faker::Hacker.say_something_smart }

    trait :with_cards do
      transient do
        story_count 5
        fool_count 10
        crisis_count 10
        bad_decision_count 10
      end

      after :build do |expansion, evaluator|
        expansion.cards << build_list(:story, evaluator.story_count, expansion: expansion)
        expansion.cards << build_list(:fool, evaluator.fool_count, expansion: expansion)
        expansion.cards << build_list(:crisis, evaluator.crisis_count, expansion: expansion)
        expansion.cards << build_list(:bad_decision, evaluator.bad_decision_count, expansion: expansion)
      end
    end
  end
end
