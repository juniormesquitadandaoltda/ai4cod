require 'rails_helper'

RSpec.describe Vehicle, type: :model do
  describe '.include' do
    it { is_expected.to be_is_a(::Associations::Vehicle) }
    it { is_expected.to be_is_a(::Validations::Vehicle) }
  end
end
