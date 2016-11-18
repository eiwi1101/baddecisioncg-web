# == Schema Information
#
# Table name: messages
#
#  id            :integer          not null, primary key
#  game_lobby_id :integer
#  user_id       :integer
#  message       :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'rails_helper'

describe Message, type: :model do
  it { is_expected.to belong_to :game_lobby }
  it { is_expected.to belong_to :user }
  it { is_expected.to validate_presence_of :game_lobby }
  it { is_expected.to validate_presence_of :user }
  it { is_expected.to validate_presence_of :message }

  it 'has a valid factory' do
    expect(build :message).to be_valid
  end
end
