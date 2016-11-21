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
#

require 'rails_helper'

describe GameLobby, type: :model do
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to have_many :games }
  it { is_expected.to have_many :messages }
  it { is_expected.to have_many :users }
  it { is_expected.to have_many :game_lobby_users }

  it 'has a valid factory' do
    expect(build :game_lobby).to be_valid
    expect(build(:game_lobby, :with_users).users.length).to eq 2
  end
end
