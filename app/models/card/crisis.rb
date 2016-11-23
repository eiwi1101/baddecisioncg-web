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

class Card::Crisis < Card
  def type_string
    'crisis'
  end
end
