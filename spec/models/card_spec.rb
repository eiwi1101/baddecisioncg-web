# == Schema Information
#
# Table name: cards
#
#  id           :integer          not null, primary key
#  type         :string
#  text         :text
#  expansion_id :integer
#

require 'rails_helper'

describe Card, type: :model do
  it { is_expected.to belong_to :expansion }
  it { is_expected.to validate_presence_of :expansion }
  it { is_expected.to validate_presence_of :text }

  it 'has a valid factory' do
    expect(create :story).to be_valid
    expect(create :fool).to be_valid
    expect(create :crisis).to be_valid
    expect(create :bad_decision).to be_valid
  end
end
