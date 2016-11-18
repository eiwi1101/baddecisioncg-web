require 'rails_helper'

describe Card, type: :model do
  it { is_expected.to belong_to :expansion }
  it { is_expected.to validate_presence_of :expansion }
  it { is_expected.to validate_presence_of :text }
end
