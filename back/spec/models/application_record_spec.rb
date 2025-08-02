require 'rails_helper'

RSpec.describe ApplicationRecord, type: :model do
  subject { build(:subscription) }

  describe '.include' do
    it { is_expected.to be_is_a(::Associations::ApplicationRecord) }
    it { is_expected.to be_is_a(::Validations::ApplicationRecord) }
  end
end
