# == Schema Information
#
# Table name: players
#
#  id            :integer          not null, primary key
#  game_id       :integer
#  lobby_user_id :integer
#  score         :integer
#  order         :integer
#  guid          :string
#  deleted_at    :datetime
#

require 'rails_helper'

describe Player, type: :model do
  it { is_expected.to belong_to :game }
  it { is_expected.to belong_to :lobby_user }
  it { is_expected.to have_many :player_cards }
  it { is_expected.to have_many :cards }
  it { is_expected.to have_many :expansions }
  it { is_expected.to validate_uniqueness_of :guid }
  it { is_expected.to act_as_paranoid }

  it 'has a valid factory' do
    expect(build :player).to be_valid
    expect(build :player, :with_hand).to be_valid
    expect(build :player, :with_discarded).to be_valid
  end
end
