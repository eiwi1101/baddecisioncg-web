# == Schema Information
#
# Table name: game_lobbies
#
#  id         :integer          not null, primary key
#  name       :string
#  private    :boolean
#  token      :string
#  password   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  deleted_at :datetime
#

require 'rails_helper'

describe GameLobby, type: :model do
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_uniqueness_of :token }
  it { is_expected.to have_many :games }
  it { is_expected.to have_many :messages }
  it { is_expected.to have_many :users }
  it { is_expected.to have_many :game_lobby_users }
  it { is_expected.to act_as_paranoid }

  let(:lobby) { build :game_lobby }
  subject { lobby }

  describe '#join' do
    context 'when alive' do
      before { lobby.join(build :user) }
      its(:game_lobby_users) { is_expected.to have(1).items }
    end

    context 'when password protected' do
      let(:lobby) { build :game_lobby, password: 'fishsticks' }

      context 'with invalid password' do
        it { expect { lobby.join(build(:user), 'asdfasdf') }.to raise_exception Exceptions::LobbyPermissionViolation }
      end

      context 'with valid password' do
        before { lobby.join(build(:user), 'fishsticks') }
        its(:game_lobby_users) { is_expected.to have(1).items }
      end
    end

    context 'when dead' do
      let(:lobby) { build :game_lobby, :deleted }
      it { expect { lobby.join(build :user) }.to raise_exception Exceptions::LobbyClosedViolation }
    end
  end

  describe '#leave' do
    let(:lobby) { create :game_lobby, :with_users, user_count: 3 }

    context 'when dead' do
      let(:lobby) { create :game_lobby, :deleted, :with_users, user_count: 3 }
      it { expect { lobby.leave(lobby.game_lobby_users.last.user) }.to raise_exception Exceptions::LobbyClosedViolation }
    end

    context 'when spectating' do
      before { lobby.leave(lobby.game_lobby_users.last.user) }
      its(:game_lobby_users) { is_expected.to have(2).items }
    end

    context 'when in a game' do
      let(:game) { create :game, game_lobby: lobby }

      before do
        game.join(lobby.game_lobby_users.last)
        lobby.leave(lobby.game_lobby_users.last.user)
        game.reload
      end

      it { expect(game).to be_abandoned }
      its(:game_lobby_users) { is_expected.to have(2).items }
    end

    context 'when last person' do
      let(:lobby) { create :game_lobby, :with_users, user_count: 1 }
      before { lobby.leave(lobby.game_lobby_users.last.user) }

      it { is_expected.to be_deleted }
    end
  end

  describe '#token' do
    context 'before validate' do
      its(:token) { is_expected.to be_nil }
    end

    context 'after validate' do
      before { lobby.valid? }
      its(:token) { is_expected.to_not be_nil }
    end

    it 'validates unique' do
      lobby.save!
      new_lobby = build :game_lobby, token: lobby.token

      expect(new_lobby).to_not be_valid
      expect(new_lobby).to have(1).errors_on :token
    end
  end

  it 'has a valid factory' do
    expect(build :game_lobby).to be_valid
    expect(build(:game_lobby, :with_users).users.length).to eq 2
  end
end
