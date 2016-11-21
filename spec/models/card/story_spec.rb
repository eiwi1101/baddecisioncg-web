require 'rails_helper'

describe Card::Story, type: :model do
  let(:game)  { create :game, :with_player_cards }
  let(:round) { create :round, game: game, story_card: game.cards.stories.first }

  describe '::for_game' do
    subject { Card::Story.for_game(round.game) }
    it { is_expected.to have(4).items }
  end

  describe '::discarded_for_game' do
    subject { Card::Story.discarded_for_game(round.game) }
    it { is_expected.to have(1).items }
  end

  describe '::in_hand_for_game' do
    subject { Card::Story.in_hand_for_game(round.game) }
    it { is_expected.to have(3).items }
  end

  context 'without discarded cards' do
    let(:round) { create :round, game: game }

    describe '::in_hand_for_game' do
      subject { Card::Story.in_hand_for_game(round.game) }
      it { is_expected.to have(4).items }
    end

    describe '::discarded_for_game' do
      subject{ Card::Story.discarded_for_game(round.game) }
      it { is_expected.to have(0).items }
    end
  end

  context 'with all discarded cards' do
    before do
      game.cards.stories.collect { |c| create :round, game: game, story_card: c }
    end

    describe '::in_hand_for_game' do
      subject { Card::Story.in_hand_for_game(round.game) }
      it { is_expected.to have(0).items }
    end

    describe '::discarded_for_game' do
      subject { Card::Story.discarded_for_game(round.game) }
      it { is_expected.to have(4).items }
    end
  end
end
