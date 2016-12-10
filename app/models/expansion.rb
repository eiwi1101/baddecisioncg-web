# == Schema Information
#
# Table name: expansions
#
#  id         :integer          not null, primary key
#  name       :string
#  uuid       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Expansion < ApplicationRecord
  include HasGuid

  has_many :cards, class_name: Card

  scope :default, -> { all }

  has_guid :uuid, type: :uuid

  validates_presence_of :name

  self.per_page = 10

  scoped_search on: :name
end
