require 'rails_helper'

RSpec.describe Subscription, type: :model do
  describe '.include' do
    it { is_expected.to be_is_a(::Associations::Subscription) }
    it { is_expected.to be_is_a(::Validations::Subscription) }
  end
end
