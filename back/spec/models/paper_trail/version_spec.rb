require 'rails_helper'

module PaperTrail
  RSpec.describe Version, type: :model do
    describe '.include' do
      it { is_expected.to be_is_a(::Associations::PaperTrail::Version) }
      it { is_expected.to be_is_a(::Validations::PaperTrail::Version) }
    end
  end
end
