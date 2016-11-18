# == Schema Information
#
# Table name: expansions
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Expansion < ApplicationRecord
  has_many :cards

  validates_presence_of :name
end
