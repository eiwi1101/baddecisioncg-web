require 'rails_helper'

describe User, type: :model do
  it { is_expected.to have_many :expansions }
  it { is_expected.to have_many :friends }
  it { is_expected.to validate_confirmation_of :password }
  it { is_expected.to validate_presence_of :username }
  it { is_expected.to validate_presence_of :email }
  it { is_expected.to validate_presence_of :display_name }
  it { is_expected.to validate_uniqueness_of :username }
  it { is_expected.to validate_uniqueness_of :email }
end
