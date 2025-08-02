require 'rails_helper'

RSpec.describe Called, type: :model do
  describe '.include' do
    it { is_expected.to be_is_a(::Associations::Called) }
    it { is_expected.to be_is_a(::Validations::Called) }
  end
end
