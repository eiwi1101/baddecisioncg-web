# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  username        :string
#  email           :string
#  display_name    :string
#  password_digest :string
#  admin           :boolean
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

FactoryGirl.define do
  factory :user do
    sequence(:username) { |i| "someuser#{i}" }
    sequence(:email) { |i| "user.#{i}@example.com" }
    display_name { Faker::Name.name }
    password 'fishsticks'
  end
end
