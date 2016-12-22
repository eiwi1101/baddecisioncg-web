# == Schema Information
#
# Table name: lobby_users
#
#  id         :integer          not null, primary key
#  lobby_id   :integer
#  user_id    :integer
#  moderator  :boolean
#  admin      :boolean
#  deleted_at :datetime
#  guid       :string
#  name       :string
#

require 'rails_helper'

describe LobbyUser, type: :model do
  it { is_expected.to validate_presence_of :lobby }
  it { is_expected.to belong_to :user }
  it { is_expected.to belong_to :lobby }
  it { is_expected.to act_as_paranoid }

  it 'has a valid spec' do
    expect(build :lobby_user).to be_valid
  end

  it 'serializes without saving' do
    user = build :lobby_user
    json = LobbyUserSerializer.new(user).as_json
    expect(json).to be_a Hash # Just a simple sanity test.
  end
end
