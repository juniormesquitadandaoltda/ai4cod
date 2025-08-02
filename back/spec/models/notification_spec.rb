require 'rails_helper'

RSpec.describe Notification, type: :model do
  describe '.include' do
    it { is_expected.to be_is_a(::Associations::Notification) }
    it { is_expected.to be_is_a(::Validations::Notification) }
  end
end
