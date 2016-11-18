require 'rails_helper'

describe Player, type: :model do
  it { is_expected.to belong_to :game }
  it { is_expected.to belong_to :user }
  it { is_expected.to have_many :player_cards }
  it { is_expected.to have_many :cards }
end
