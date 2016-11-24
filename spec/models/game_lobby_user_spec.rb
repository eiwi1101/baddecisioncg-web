# == Schema Information
#
# Table name: game_lobby_users
#
#  id            :integer          not null, primary key
#  game_lobby_id :integer
#  user_id       :integer
#  moderator     :boolean
#  admin         :boolean
#  deleted_at    :datetime
#

require 'rails_helper'

describe GameLobbyUser, type: :model do
  it { is_expected.to validate_presence_of :user }
  it { is_expected.to validate_presence_of :game_lobby }
  it { is_expected.to belong_to :user }
  it { is_expected.to belong_to :game_lobby }
  it { is_expected.to act_as_paranoid }

  it 'has a valid spec' do
    expect(build :game_lobby_user).to be_valid
  end
end
