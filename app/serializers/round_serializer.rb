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
             :blank_cards,
             :player_cards

  has_one :story, serializer: CardSerializer

  def id
    object.guid
  end

  def story
    object.story_card
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

  def blank_cards
    object.card_blanks.collect { |b| if b.nil?
      {}
    else
      PlayerCardSerializer.new(b).as_json
    end }
  end
end
