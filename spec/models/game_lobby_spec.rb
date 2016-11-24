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
      # doesn't do a whole lot
    end

    context 'when dead' do
      # doesn't do anything
    end
  end

  describe '#leave' do
    context 'when spectating' do
      # just gtfo's
    end

    context 'when in a game' do
      # leaves the game as well.
    end

    context 'when last person' do
      # shuts down lobby
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
