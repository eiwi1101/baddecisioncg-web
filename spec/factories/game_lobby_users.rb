# == Schema Information
#
# Table name: game_lobby_users
#
#  id            :integer          not null, primary key
#  game_lobby_id :integer
#  user_id       :integer
#  moderator     :boolean
#  admin         :boolean
#

FactoryGirl.define do
  factory :game_lobby_user do
    game_lobby
    user

    trait :moderator do
      moderator true
    end

    trait :admin do
      admin true
    end
  end
end
