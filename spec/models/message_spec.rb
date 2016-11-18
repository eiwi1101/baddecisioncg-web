require 'rails_helper'

describe Message, type: :model do
  it { is_expected.to belong_to :game_lobby }
  it { is_expected.to belong_to :user }
  it { is_expected.to validate_presence_of :game_lobby }
  it { is_expected.to validate_presence_of :user }
  it { is_expected.to validate_presence_of :message }
end
