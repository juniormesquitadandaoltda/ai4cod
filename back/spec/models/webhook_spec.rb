require 'rails_helper'

RSpec.describe Webhook, type: :model do
  describe '.include' do
    it { is_expected.to be_is_a(::Associations::Webhook) }
    it { is_expected.to be_is_a(::Validations::Webhook) }
  end
end
