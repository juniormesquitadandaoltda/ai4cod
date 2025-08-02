require 'rails_helper'

RSpec.describe Facilitator, type: :model do
  describe '.include' do
    it { is_expected.to be_is_a(::Associations::Facilitator) }
    it { is_expected.to be_is_a(::Validations::Facilitator) }
  end
end
