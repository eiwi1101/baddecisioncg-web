# == Schema Information
#
# Table name: rounds
#
#  id                 :integer          not null, primary key
#  game_id            :integer
#  number             :integer
#  bard_player_id     :integer
#  winning_player_id  :integer
#  fool_pc_id         :integer
#  crisis_pc_id       :integer
#  bad_decision_pc_id :integer
#  story_card_id      :integer
#  status             :string
#  guid               :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class RoundSerializer < ActiveModel::Serializer
  attributes :id,
             :status,
             :bard_player_guid,
             :winning_player_guid,
             :player_cards

  has_one :story_card, serializer: CardSerializer, key: :story
  has_one :fool_pc, serializer: PlayerCardSerializer, key: :fool
  has_one :crisis_pc, serializer: PlayerCardSerializer, key: :crisis
  has_one :bad_decision_pc, serializer: PlayerCardSerializer, key: :bad_decision


  def id
    object.guid
  end

  def player_cards
    object.submitted_player_cards&.collect { |p| PlayerCardSerializer.new(p).as_json }
  end

  def bard_player_guid
    object.bard_player&.guid
  end

  def winning_player_guid
    object.winning_player&.guid
  end
end
