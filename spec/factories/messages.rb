# == Schema Information
#
# Table name: messages
#
#  id         :integer          not null, primary key
#  lobby_id   :integer
#  user_id    :integer
#  message    :text
#  guid       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :message do
    lobby
    user
    message { Faker::Lorem.paragraph }
  end
end
