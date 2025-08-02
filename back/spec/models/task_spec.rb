require 'rails_helper'

RSpec.describe Task, type: :model do
  describe '.include' do
    it { is_expected.to be_is_a(::Associations::Task) }
    it { is_expected.to be_is_a(::Validations::Task) }
  end
end
