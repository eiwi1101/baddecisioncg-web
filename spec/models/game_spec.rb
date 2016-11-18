# == Schema Information
#
# Table name: games
#
#  id              :integer          not null, primary key
#  score_limit     :integer
#  game_lobby_id   :integer
#  winning_user_id :integer
#  status          :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'rails_helper'

describe Game, type: :model do
  it { is_expected.to belong_to :game_lobby }
  it { is_expected.to belong_to :winning_user }
  it { is_expected.to have_many :players }
  it { is_expected.to have_many :rounds }
  it { is_expected.to validate_presence_of :game_lobby }
  it { is_expected.to_not validate_presence_of :score_limit }
  it { is_expected.to_not validate_presence_of :winning_user }

  subject { game }
  let(:game) { build :game }

  context 'when finished' do
    let(:game) { build :game, :finished }
    it { is_expected.to validate_presence_of :winning_user }
  end

  it 'has valid factory' do
    expect(build :game).to be_valid
    expect(build(:game, :finished)).to be_valid
  end
end
