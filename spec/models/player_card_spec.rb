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
end
