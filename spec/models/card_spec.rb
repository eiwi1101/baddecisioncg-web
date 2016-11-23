# == Schema Information
#
# Table name: cards
#
#  id           :integer          not null, primary key
#  type         :string
#  text         :text
#  expansion_id :integer
#  uuid         :string
#

require 'rails_helper'

describe Card, type: :model do
  it { is_expected.to belong_to :expansion }
  it { is_expected.to validate_presence_of :expansion }
  it { is_expected.to validate_presence_of :text }
  it { is_expected.to validate_uniqueness_of :uuid }

  describe '#type_string' do
    let(:card) { build :card }
    subject { card.type_string }

    it { is_expected.to be_nil }

    context 'when Story' do
      let(:card) { build :story }
      it { is_expected.to eq 'story' }
    end

    context 'when Bad Decision' do
      let(:card) { build :bad_decision }
      it { is_expected.to eq 'bad_decision' }
    end

    context 'when Fool' do
      let(:card) { build :fool }
      it { is_expected.to eq 'fool' }
    end

    context 'when Crisis' do
      let(:card) { build :crisis }
      it { is_expected.to eq 'crisis' }
    end

    context 'when Fishsticks' do
      let(:card) { build :card, type: 'Fishsticks' }
      it { is_expected.to be_nil }
    end
  end

  it 'has a valid factory' do
    expect(create :story).to be_valid
    expect(create :fool).to be_valid
    expect(create :crisis).to be_valid
    expect(create :bad_decision).to be_valid
  end
end
