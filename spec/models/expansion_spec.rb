# == Schema Information
#
# Table name: expansions
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

describe Expansion, type: :model do
  it { is_expected.to have_many :cards }
  it { is_expected.to validate_presence_of :name }

  it 'has a valid factory' do
    expect(build :expansion).to be_valid
    expect(build(:expansion, :with_cards).cards.length).to eq 5
  end
end
