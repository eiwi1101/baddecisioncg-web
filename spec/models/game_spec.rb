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

  context 'when finished' do
    let(:game) { build :game, :finished }
    it { is_expected.to validate_presence_of :winning_user }
  end
end
