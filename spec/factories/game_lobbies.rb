# == Schema Information
#
# Table name: game_lobbies
#
#  id         :integer          not null, primary key
#  name       :string
#  private    :boolean
#  token      :string
#  password   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :game_lobby do
    name { Faker::Hacker.say_something_smart }

    trait :private do
      private :true
    end

    trait :with_users do
      transient do
        user_count 5
      end

      after :build do |game_lobby, evaluator|
        game_lobby.users << build_list(:user, evaluator.user_count, :with_expansions)
        game_lobby.game_lobby_users.first.admin = true
      end
    end
  end
end
