# == Schema Information
#
# Table name: rounds
#
#  id                 :integer          not null, primary key
#  game_id            :integer
#  number             :integer
#  bard_player_id     :integer
#  winning_player_id  :integer
#  fool_pc_id         :integer
#  crisis_pc_id       :integer
#  bad_decision_pc_id :integer
#  story_card_id      :integer
#  status             :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

require 'rails_helper'

describe Round, type: :model do
  it { is_expected.to belong_to :game }
  it { is_expected.to belong_to :bard_player }
  it { is_expected.to belong_to :winning_player }
  it { is_expected.to belong_to :story_card }
  it { is_expected.to belong_to :fool_pc }
  it { is_expected.to belong_to :crisis_pc }
  it { is_expected.to belong_to :bad_decision_pc }
  it { is_expected.to have_many :player_cards }
  it { is_expected.to validate_presence_of :game }
  it { is_expected.to validate_presence_of :bard_player }

  subject { round }
  let(:round) { build :round }

  context 'when setup' do
    let(:round) { build :round, :setup }
    it { is_expected.to validate_presence_of :story_card }
  end

  context 'when player_pick' do
    let(:round) { build :round, :player_pick }
    it { is_expected.to validate_presence_of :fool_pc }
    it { is_expected.to validate_presence_of :crisis_pc }
  end

  context 'when bard_pick' do
    context 'without submissions' do
      let(:round) { build :round, :bard_pick, :without_submissions }
      it { is_expected.to_not be_valid }
      it { is_expected.to have(1).errors_on :player_cards }
    end

    context 'with submissions' do
      let(:round) { build :round, :bard_pick }
      it { is_expected.to be_valid }
      it { is_expected.to have_at_least(1).player_cards }
    end
  end

  context 'when finished' do
    let(:round) { build :round, :finished }
    it { is_expected.to validate_presence_of :bad_decision_pc }
    it { is_expected.to validate_presence_of :winning_player }
  end

  describe 'drawing story card' do
    let(:game)  { create :game, :with_player_cards }
    let(:round) { create :round, game: game, story_card: game.cards.stories.first }

    subject { round }
    before  { round.draw }

    its(:status) { is_expected.to eq 'setup' }
    its(:story_card) { is_expected.to_not be_nil }
    its(:story_card) { is_expected.to_not eq game.cards.stories.first }

    context 'with empty story deck' do
      let(:game) { create :game, :with_players }

      its(:status) { is_expected.to be_nil }
      its(:story_card) { is_expected.to be_nil }

      describe '#game' do
        subject { round.game }
        its(:cards) { is_expected.to be_empty }
      end
    end
  end

  describe 'picking bard cards' do

  end

  it 'has a valid factory' do
    expect(build :round).to be_valid
    expect(build :round, :setup).to be_valid
    expect(build :round, :player_pick).to be_valid
    expect(build :round, :bard_pick).to be_valid
    expect(build :round, :finished).to be_valid
  end
end
