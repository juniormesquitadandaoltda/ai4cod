require 'rails_helper'

RSpec.describe FieldEnumValidator, type: :validator do
  subject { described_class.new(User) }

  describe '#validate_each' do
    xit 'must be valid'

    xit 'must be invalid'
  end
end
