require 'rails_helper'

describe GameLobby, type: :model do
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to have_many :games }
  it { is_expected.to have_many :messages }
  it { is_expected.to have_many :users }
  it { is_expected.to have_many :game_lobby_users }
end
