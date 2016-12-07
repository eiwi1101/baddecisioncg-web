# == Schema Information
#
# Table name: lobbies
#
#  id         :integer          not null, primary key
#  name       :string
#  private    :boolean
#  token      :string
#  password   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  deleted_at :datetime
#

FactoryGirl.define do
  factory :lobby do
    name { Faker::Hacker.say_something_smart }

    trait :private do
      private :true
    end

    trait :deleted do
      deleted_at { DateTime.now }
    end

    trait :with_users do
      transient do
        user_count 2
        user_attributes [:with_expansions]
      end

      after :build do |lobby, evaluator|
        lobby.users << build_list(:user, evaluator.user_count, *evaluator.user_attributes)
        lobby.lobby_users.first.admin = true
      end
    end
  end
end
