require 'rails_helper'

RSpec.describe Field, type: :model do
  describe '.include' do
    it { is_expected.to be_is_a(::Associations::Field) }
    it { is_expected.to be_is_a(::Validations::Field) }
  end
end
