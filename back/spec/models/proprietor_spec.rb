require 'rails_helper'

RSpec.describe Proprietor, type: :model do
  describe '.include' do
    it { is_expected.to be_is_a(::Associations::Proprietor) }
    it { is_expected.to be_is_a(::Validations::Proprietor) }
  end
end
