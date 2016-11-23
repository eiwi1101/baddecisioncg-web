# == Schema Information
#
# Table name: messages
#
#  id            :integer          not null, primary key
#  game_lobby_id :integer
#  user_id       :integer
#  message       :text
#  guid          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

FactoryGirl.define do
  factory :message do
    game_lobby
    user
    message { Faker::Lorem.paragraph }
  end
end
