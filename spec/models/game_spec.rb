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
    expect(game.cards.count).to eq 10
    expect(game.cards.stories.count).to eq 4
    expect(game_2.expansions.count).to eq 1
  end

  describe '#join' do
    let(:game_lobby) { build :game_lobby, :with_users }
    let(:user) { game_lobby.game_lobby_users.first }
    let(:game) { build :game, game_lobby: game_lobby }

    it 'joins player to game' do
      expect(game.join(user)).to eq true
      expect(game.players.first.user).to eq user.user
    end

    it 'rejects user from another lobby' do
      user = build :game_lobby_user
      expect { game.join(user) }.to raise_exception Exceptions::UserLobbyViolation
    end

    it 'rejects joins on in_progress game' do
      game = build :game, :in_progress, game_lobby: game_lobby
      expect { game.join(user) }.to raise_exception Exceptions::GameStatusViolation
    end

    it 'rejects user already in game' do
      expect(game.join(user)).to eq true
      expect { game.join(user) }.to raise_exception Exceptions::PlayerExistsViolation
      expect(game.players).to have(1).items
    end
  end

  describe '#start!' do
    let(:game_lobby) { build :game_lobby, :with_users }
    let(:game) { build :game, game_lobby: game_lobby }
    before { game.join(game_lobby.game_lobby_users.first) }

    it 'will not start without players' do
      expect(game.start).to eq false
      expect(game.errors[:players]).to have(1).items
      expect(game.status).to be_nil
    end

    it 'starts with at least two players' do
      game.join(game_lobby.game_lobby_users.last)
      expect(game.start).to eq true
      expect(game.status).to eq 'in_progress'
    end
  end

  describe '#leave' do
    let(:game_lobby) { build :game_lobby, :with_users, user_count: 3 }
    let(:game) { build :game, game_lobby: game_lobby }
    before { game_lobby.game_lobby_users.each { |u| game.join(u) } }
    before { game.start! }

    it 'removes player' do
      expect(game.players.length).to eq 3
      game.remove(game_lobby.game_lobby_users.last)
      expect(game.players.length).to eq 2
      expect(game.reload.players.length).to eq 2
    end

    it 'complains about unknown users' do
      user = build :game_lobby_user
      expect { game.remove(user) }.to raise_exception Exceptions::UserLobbyViolation
    end

    it 'complains about users not in the game' do
      expect(game.remove(game_lobby.game_lobby_users.last)).to eq true
      expect { game.remove(game_lobby.game_lobby_users.last) }.to raise_exception Exceptions::PlayerExistsViolation
    end

    it 'ends game if we drop below two people' do
      expect(game.remove(game_lobby.game_lobby_users.first)).to eq true
      expect(game.remove(game_lobby.game_lobby_users.last)).to eq true
      expect(game.status).to eq 'finished'
      expect(game.players.length).to eq 1
      expect(game.winning_user).to eq game_lobby.game_lobby_users.second.user
    end
  end

  describe '#finish!' do
    let(:game) { build :game, :in_progress }
    before { game.players.second.update_attributes(score: 2) }

    it 'assigns a winner' do
      expect(game.finish).to eq true
      expect(game.winning_user).to eq game.players.second.user
    end

    it 'requires an in progress game' do
      game = build :game, :with_players
      expect(game.finish).to eq false
    end

    it 'does not explode without players' do
      game = build :game, status: 'in_progress'
      expect(game.finish).to eq false
    end
  end

  describe '#next_round' do
    let(:game) { create :game, :in_progress, :with_player_cards }
    let(:round) { game.next_round }
    subject { round }

    it 'rotates players' do
      round.bard_play(round.bard_player.player_cards.fools.first)
      round.bard_play(round.bard_player.player_cards.crisis.first)
      round.reveal!
      round.player_play(game.players.second.player_cards.bad_decisions.first)
      round.all_in!
      round.bard_pick(round.player_cards.bad_decisions.first)
      round.finish!

      new_round = game.next_round

      expect(new_round).to be_setup
      expect(new_round.bard_player).to eq game.players.second
    end

    context 'without current round' do
      its(:status) { is_expected.to eq 'setup' }
      its(:bard_player) { is_expected.to eq game.players.first }
    end

    context 'with game in invalid state' do
      let(:game) { build :game }
      it { expect { game.next_round }.to raise_exception Exceptions::GameStatusViolation }
    end

    context 'with current unfinished round' do
      before { game.rounds << build(:round, :setup) }
      it { expect { game.next_round }.to raise_exception Exceptions::RoundOrderViolation }
    end

    context 'with finished round' do
      before { game.rounds << build(:round, :finished) }
      its(:status) { is_expected.to eq 'setup' }
    end

    context 'when end of game' do
      let(:game) { create :game, :in_progress, :with_player_cards, score_limit: 1 }
      before { game.rounds << build(:round, :finished) }
      it { is_expected.to be_nil }

      it 'ends game' do
        game.next_round
        expect(game.status).to eq 'finished'
      end
    end
  end

  it 'has valid factory' do
    expect(build :game).to be_valid
    expect(build :game, :in_progress).to be_valid
    expect(build :game, :finished).to be_valid
  end
end
