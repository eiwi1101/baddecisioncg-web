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
  it { is_expected.to have_many :expansions }
  it { is_expected.to have_many :cards }
  it { is_expected.to validate_presence_of :game_lobby }
  it { is_expected.to_not validate_presence_of :score_limit }
  it { is_expected.to_not validate_presence_of :winning_user }

  subject { game }
  let(:game) { build :game }

  context 'when finished' do
    let(:game) { build :game, :finished }
    it { is_expected.to validate_presence_of :winning_user }
  end

  it 'does all the things with all the cards' do
    user_1 = create :user
    user_2 = create :user
    user_1.expansions << build(:expansion, :with_cards)
    user_2.expansions << build(:expansion, :with_cards)

    lobby = create :game_lobby
    lobby.users << user_1
    lobby.users << user_2

    game = lobby.games.create
    game_2 = lobby.games.create

    expect(game.expansions.count).to eq 0

    game.players << build(:player, user: user_1, game: game)
    game.players << build(:player, user: user_2, game: game)
    game_2.players << build(:player, user: user_2, game: game_2)

    expect(game.expansions.count).to eq 2
    expect(game.cards.count).to eq 70
    expect(game.cards.stories.count).to eq 10
    expect(game_2.expansions.count).to eq 1

    game.rounds << build(:round, game: game, story_card: game.cards.stories.first)

    expect(Card::Story.discarded_for_game(game).count).to eq 1
    expect(Card::Story.in_hand_for_game(game).count).to  eq 9
    expect(Card::Story.in_hand_for_game(game_2).count).to eq 5
  end

  it 'has valid factory' do
    expect(build :game).to be_valid
    expect(build(:game, :finished)).to be_valid
  end
end
