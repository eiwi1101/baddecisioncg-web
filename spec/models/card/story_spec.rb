# == Schema Information
#
# Table name: cards
#
#  id           :integer          not null, primary key
#  type         :string
#  text         :text
#  expansion_id :integer
#

require 'rails_helper'

describe Card::Story, type: :model do
  let(:game)  { create :game, :with_player_cards }
  let(:round) { create :round, game: game, story_card: game.cards.stories.first }

  describe 'card order' do
    let(:story) { build :story, text: self.class.description }
    subject { story }

    context '%{fool} + %{crisis} = %{bad_decision}' do
      it { expect(story.card_order).to eq %w{fool crisis bad_decision} }
      it { is_expected.to be_valid }
    end

    context 'All %{crisis} become %{fool}\'s %{Bad_Decision}' do
      it { expect(story.card_order).to eq %w{crisis fool Bad_Decision} }
      it { is_expected.to_not be_valid }
    end

    context '%{crisis} %{FOOL} Missing One' do
      it { expect(story.card_order).to eq %w{crisis FOOL} }
      it { is_expected.to_not be_valid }
    end

    context '%{crisis} %{fool} %{bad_decision} %{extra}' do
      it { expect(story.card_order).to eq %w{crisis fool bad_decision extra} }
      it { is_expected.to_not be_valid}
    end
  end

  describe 'display_text' do
    let(:story) { build :story, text: '%{fool} + %{crisis} = %{bad_decision}' }
    let(:round) { build :round, story_card: story }

    subject { story.display_text(round) }

    context 'with empty blanks' do
      it { is_expected.to eq 'FOOL + CRISIS = BAD DECISION' }
    end

    context 'with partial blanks' do
      before do
        round.fool_pc   = build :player_card, card_text: 'Programmer'
        round.crisis_pc = build :player_card, card_text: '"creative freedom"'
      end

      it { is_expected.to eq 'Programmer + "creative freedom" = BAD DECISION' }
    end
  end

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
