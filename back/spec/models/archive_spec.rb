require 'rails_helper'

RSpec.describe Archive, type: :model do
  it { is_expected.to be_is_a(::ActiveStorage::Attachment) }

  describe '.include' do
    it { is_expected.to be_is_a(::Associations::Archive) }
    it { is_expected.to be_is_a(::Validations::Archive) }
  end
end
