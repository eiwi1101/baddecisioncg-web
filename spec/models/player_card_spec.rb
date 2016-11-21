# == Schema Information
#
# Table name: player_cards
#
#  id        :integer          not null, primary key
#  player_id :integer
#  card_id   :integer
#  round_id  :integer
#

require 'rails_helper'

describe PlayerCard, type: :model do
  it { is_expected.to belong_to :player }
  it { is_expected.to belong_to :card }

  describe '#discarded?' do
    let(:player_card) { build :player_card }
    subject { player_card.discarded? }

    context 'when in hand' do
      it { is_expected.to eq false }
    end

    context 'when discarded' do
      let(:player_card) { build :player_card, :discarded }
      it { is_expected.to eq true }
    end
  end
end
