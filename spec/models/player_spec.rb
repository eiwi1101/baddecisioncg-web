# == Schema Information
#
# Table name: players
#
#  id      :integer          not null, primary key
#  game_id :integer
#  user_id :integer
#  score   :integer
#  order   :integer
#

require 'rails_helper'

describe Player, type: :model do
  it { is_expected.to belong_to :game }
  it { is_expected.to belong_to :user }
  it { is_expected.to have_many :player_cards }
  it { is_expected.to have_many :cards }

  it 'has a valid factory' do
    expect(build :player).to be_valid
    expect(build(:player, :with_hand).cards.length).to eq 15
    expect(create(:player, :with_hand, :with_discarded).player_cards.length).to eq 25
  end
end
