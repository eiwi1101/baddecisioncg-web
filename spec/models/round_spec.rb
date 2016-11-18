require 'rails_helper'

describe Round, type: :model do
  it { is_expected.to belong_to :game }
  it { is_expected.to belong_to :bard_player }
  it { is_expected.to belong_to :winning_player }
  it { is_expected.to belong_to :story_card }
  it { is_expected.to belong_to :first_pc }
  it { is_expected.to belong_to :second_pc }
  it { is_expected.to belong_to :third_pc }
  it { is_expected.to have_many :player_cards }
  it { is_expected.to validate_presence_of :game }
  it { is_expected.to validate_presence_of :bard_player }

  subject { round }

  context 'when setup' do
    let(:round) { build :round, :setup }
    it { is_expected.to validate_presence_of :story_card }
  end

  context 'when player_pick' do
    let(:round) { build :round, :player_pick }
    it { is_expected.to validate_presence_of :first_pc }
    it { is_expected.to validate_presence_of :second_pc }
  end

  context 'when bard_pick' do
    context 'without submissions' do
      let(:round) { build :round, :bard_pick }
      it { is_expected.to_not be_valid }
      it { is_expected.to have(1).errors_on :player_cards }
    end

    context 'with submissions' do
      let(:round) { build :round, :with_player_cards }
      it { is_expected.to be_valid }
    end
  end

  context 'when finished' do
    let(:round) { build :round, :finished }
    it { is_expected.to validate_presence_of :third_pc }
    it { is_expected.to validate_presence_of :winning_player }
  end
end
