# == Schema Information
#
# Table name: cards
#
#  id           :integer          not null, primary key
#  type         :string
#  text         :text
#  expansion_id :integer
#

FactoryGirl.define do
  factory :card do
    expansion
    text { Faker::Lorem.sentence }

    factory :story, class: Card::Story do
    end

    factory :fool, class: Card::Fool do
    end

    factory :crisis, class: Card::Crisis do
    end

    factory :bad_decision, class: Card::BadDecision do
    end
  end
end
