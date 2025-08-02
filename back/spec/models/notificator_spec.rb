require 'rails_helper'

RSpec.describe Notificator, type: :model do
  describe '.include' do
    it { is_expected.to be_is_a(::Associations::Notificator) }
    it { is_expected.to be_is_a(::Validations::Notificator) }
  end
end
