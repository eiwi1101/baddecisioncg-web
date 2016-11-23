# == Schema Information
#
# Table name: players
#
#  id      :integer          not null, primary key
#  game_id :integer
#  user_id :integer
#  score   :integer
#  order   :integer
#  guid    :string
#

require 'rails_helper'

describe Player, type: :model do
  it { is_expected.to belong_to :game }
  it { is_expected.to belong_to :user }
  it { is_expected.to have_many :player_cards }
  it { is_expected.to have_many :cards }
  it { is_expected.to have_many :expansions }
  it { is_expected.to validate_uniqueness_of :guid }

  it 'has a valid factory' do
    expect(build :player).to be_valid
    expect(build :player, :with_hand).to be_valid
    expect(build :player, :with_discarded).to be_valid
  end
end
