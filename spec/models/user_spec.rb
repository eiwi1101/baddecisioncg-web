# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  username        :string
#  email           :string
#  display_name    :string
#  password_digest :string
#  admin           :boolean
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'rails_helper'

describe User, type: :model do
  it { is_expected.to have_and_belong_to_many :expansions }
  it { is_expected.to have_and_belong_to_many :friends }
  it { is_expected.to validate_presence_of :username }
  it { is_expected.to validate_presence_of :email }
  it { is_expected.to validate_presence_of :display_name }
  it { is_expected.to validate_uniqueness_of :username }
  it { is_expected.to validate_uniqueness_of :email }

  it 'has a valid factory' do
    expect(build :user).to be_valid
  end
end
