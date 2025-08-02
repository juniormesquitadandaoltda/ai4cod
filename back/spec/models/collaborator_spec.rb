require 'rails_helper'

RSpec.describe Collaborator, type: :model do
  describe '.include' do
    it { is_expected.to be_is_a(::Associations::Collaborator) }
    it { is_expected.to be_is_a(::Validations::Collaborator) }
  end
end
