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
#  guid               :string
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
  it { is_expected.to validate_uniqueness_of :guid }

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

    before  { round.draw }

    its(:status) { is_expected.to eq 'setup' }
    its(:story_card) { is_expected.to_not be_nil }
    its(:story_card) { is_expected.to_not eq game.cards.stories.first }

    it 'draws player cards' do
      player = round.game.players.first
      expect(player.player_cards).to have_at_least(1).item
    end

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
    let(:round) { build :round, :setup }

    it 'accepts first two blanks' do
      fool_1 = build :player_card, player: round.bard_player, card: build(:fool, text: 'A')
      crisis = build :player_card, player: round.bard_player, card: build(:crisis, text: 'B')
      fool_2 = build :player_card, player: round.bard_player, card: build(:fool, text: 'Z')

      expect(round.bard_play(fool_2)).to eq true
      expect(round.bard_play(crisis)).to eq true
      expect(round.bard_play(fool_1)).to eq true

      expect(fool_1.discarded?).to eq true
      expect(fool_2.discarded?).to eq false
    end

    it 'rejects third blank' do
      decision = build :player_card, player: round.bard_player, card: build(:bad_decision)
      expect { round.bard_play(decision) }.to raise_exception Exceptions::CardTypeViolation
    end

    it 'raises card hand violations' do
      fool = build :player_card, card: build(:fool)
      expect { round.bard_play(fool) }.to raise_exception Exceptions::PlayerHandViolation
    end

    it 'raises a round violation' do
      round = build :round, :player_pick
      fool  = build :player_card, card: build(:fool), player: round.bard_player
      expect { round.bard_play(fool) }.to raise_exception Exceptions::RoundOrderViolation
    end

    it 'raises discarded card violations' do
      round = build :round, :player_pick
      fool = build :player_card, card: build(:fool), player: round.bard_player, round: round
      expect { round.bard_play(fool) }.to raise_exception Exceptions::DiscardedCardViolation
    end
  end

  describe '#reveal!' do
    let(:round) { build :round, :setup }
    before { round.reveal }

    context 'without proper selections' do
      its(:status) { is_expected.to eq 'setup' }
    end

    context 'with first blanks filled' do
      let(:round)  { build :round, :setup, :bard_in }
      its(:status) { is_expected.to eq 'player_pick' }
    end
  end

  describe 'player submitting cards' do
    let(:round) { create :round, :player_pick }

    it 'accepts third blank' do
      decision_1 = create :player_card, player: round.game.players.last, card: build(:bad_decision)
      decision_2 = create :player_card, player: round.game.players.last, card: build(:bad_decision)

      expect(round.player_play(decision_1)).to eq true
      expect(round.player_cards.length).to eq 3
      expect(round.submitted_player_cards.length).to eq 1
      expect(round.player_play(decision_2)).to eq true
      expect(decision_1.reload.discarded?).to eq false
      expect(decision_2.discarded?).to eq true
    end

    it 'rejects first blank' do
      fool = build :player_card, player: round.game.players.last, card: build(:fool)
      expect { round.player_play(fool) }.to raise_exception Exceptions::CardTypeViolation
    end

    it 'rejects card hand violations' do
      decision = build :player_card, card: build(:bad_decision), player: round.bard_player
      expect { round.player_play(decision) }.to raise_exception Exceptions::PlayerHandViolation
    end

    it 'raises a round violation' do
      round = build :round, :setup
      decision = build :player_card, card: build(:bad_decision), player: round.game.players.last
      expect { round.player_play(decision) }.to raise_exception Exceptions::RoundOrderViolation
    end

    it 'raises discarded card violations' do
      decision = build :player_card, card: build(:bad_decision), player: round.game.players.last, round: round
      expect { round.player_play(decision) }.to raise_exception Exceptions::DiscardedCardViolation
    end
  end

  describe '#all_in!' do
    let(:round) { build :round, :player_pick, :players_in }
    before { round.all_in }

    context 'with all in' do
      its(:all_in?) { is_expected.to eq true }
      its(:status) { is_expected.to eq 'bard_pick' }
    end

    context 'without all in' do
      let(:round) { build :round, :player_pick }
      its(:all_in?) { is_expected.to eq false }
      its(:status) { is_expected.to eq 'player_pick' }
    end
  end

  describe 'bard picking winner' do
    let(:round) { build :round, :bard_pick }

    it 'accepts a winning card' do
      decision = round.submitted_player_cards.last
      expect(round.bard_pick(decision)).to eq true
    end

    it 'rejects the bard cards' do
      decision = round.fool_pc
      expect { round.bard_pick(decision) }.to raise_exception Exceptions::CardTypeViolation
    end

    it 'raises a round violation' do
      round = build :round, :player_pick
      round.player_cards << build(:player_card, card: build(:bad_decision))
      decision = round.player_cards.last
      expect { round.bard_pick(decision) }.to raise_exception Exceptions::RoundOrderViolation
    end

    it 'rejects other round cards' do
      round = build :round, :player_pick
      decision = build :player_card, card: build(:bad_decision)
      expect { round.bard_pick(decision) }.to raise_exception Exceptions::RoundMismatchViolation
    end
  end

  describe '#finish!' do
    let(:round) { create :round, :bard_pick, :winner_picked }
    before { round.finish }

    context 'with bard picked' do
      its(:bard_picked?) { is_expected.to eq true }
      its(:status) { is_expected.to eq 'finished' }
      its(:winning_player) { is_expected.to_not be_nil }

      describe 'winning player score' do
        it { expect(round.winning_player.score).to eq 1 }
      end
    end

    context 'without bard picked' do
      let(:round) { build :round, :bard_pick }

      it { expect(round.errors[:bad_decision_pc]).to have(1).items }
      its(:bard_picked?) { is_expected.to eq false }
      its(:status) { is_expected.to eq 'bard_pick' }
      its(:winning_player) { is_expected.to be_nil }
    end
  end

  it 'filters player cards' do
    round = create :round, :bard_pick
    expect(round.fool_pc.round).to eq round
    expect(round.submitted_player_cards).to_not include round.fool_pc
    expect(round.submitted_player_cards).to_not include round.crisis_pc
    expect(round.submitted_player_cards.collect { |pc| pc.card.type_string }.uniq).to eq %w{bad_decision}
  end

  it 'has a valid factory' do
    expect(build :round).to be_valid
    expect(build :round, :setup).to be_valid
    expect(build :round, :player_pick).to be_valid
    expect(build :round, :bard_pick).to be_valid
    expect(build :round, :finished).to be_valid
  end
end
