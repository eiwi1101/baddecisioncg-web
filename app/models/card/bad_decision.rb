# == Schema Information
#
# Table name: cards
#
#  id           :integer          not null, primary key
#  type         :string
#  text         :text
#  expansion_id :integer
#

class Card::BadDecision < Card
  def type_string
    'bad_decision'
  end
end
