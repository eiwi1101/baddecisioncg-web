# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  username        :string
#  email           :string
#  display_name    :string
#  password_digest :string
#  uuid            :string
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
    password_confirmation 'fishsticks'

    trait :with_expansions do
      transient do
        expansion_count 1
      end

      expansions { build_list :expansion, expansion_count, :with_cards }
    end
  end
end
