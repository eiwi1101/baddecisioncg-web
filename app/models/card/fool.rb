# == Schema Information
#
# Table name: cards
#
#  id           :integer          not null, primary key
#  type         :string
#  text         :text
#  expansion_id :integer
#

class Card::Fool < Card
  def type_string
    'fool'
  end
end
