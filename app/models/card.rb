# == Schema Information
#
# Table name: cards
#
#  id           :integer          not null, primary key
#  type         :string
#  text         :text
#  expansion_id :integer
#  uuid         :string
#

class Card < ApplicationRecord
  include HasGuid

  belongs_to :expansion
  has_many :player_cards

  has_guid :uuid, type: :uuid

  validates_presence_of :expansion
  validates_presence_of :text
  validates_presence_of :type
  # validates_inclusion_of :type, in: %w[fool crisis bad_decision story]

  scope :fools, -> { where(type: 'Card::Fool') }
  scope :crisis, -> { where(type: 'Card::Crisis') }
  scope :bad_decisions, -> { where(type: 'Card::BadDecision') }
  scope :stories, -> { where(type: 'Card::Story') }

  def self.types
    [
        ['Fool', 'Card::Fool'],
        ['Crisis', 'Card::Crisis'],
        ['Bad Decision', 'Card::BadDecision'],
        ['Story', 'Card::Story']
    ]
  end

  def type_string
    nil
  end

  def display_text(_=nil, _=nil)
    self.text
  end

  def to_html(round=nil)
    <<-HTML.html_safe
      <div class="game-card #{type_string}">
        <div class="card-content">#{display_text(round, '<div class="placeholder %{card}">%{text}</div>')}</div>
      </div>
    HTML
  end
end
