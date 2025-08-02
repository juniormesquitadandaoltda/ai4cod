require 'rails_helper'

RSpec.describe User, type: :model do
  describe '.include' do
    it { is_expected.to be_is_a(::Associations::User) }
    it { is_expected.to be_is_a(::Validations::User) }
  end
end
