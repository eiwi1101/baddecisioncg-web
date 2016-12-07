# == Schema Information
#
# Table name: lobby_users
#
#  id            :integer          not null, primary key
#  lobby_id :integer
#  user_id       :integer
#  moderator     :boolean
#  admin         :boolean
#  deleted_at    :datetime
#  guid          :string
#

FactoryGirl.define do
  factory :lobby_user do
    lobby
    user

    trait :moderator do
      moderator true
    end

    trait :admin do
      admin true
    end
  end
end
