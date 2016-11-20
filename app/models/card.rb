# == Schema Information
#
# Table name: cards
#
#  id           :integer          not null, primary key
#  type         :string
#  text         :text
#  expansion_id :integer
#

class Card < ApplicationRecord
  belongs_to :expansion
  has_many :player_cards

  validates_presence_of :expansion
  validates_presence_of :text

  scope :fools, -> { where(type: 'Card::Fool') }
  scope :crisis, -> { where(type: 'Card::Crisis') }
  scope :bad_decisions, -> { where(type: 'Card::BadDecisions') }
  scope :stories, -> { where(type: 'Card::Story') }
end
