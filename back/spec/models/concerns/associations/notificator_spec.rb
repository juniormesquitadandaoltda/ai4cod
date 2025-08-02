require 'rails_helper'

RSpec.describe Notificator, type: :model do
  describe '.has_paper_trail' do
    it { is_expected.to be_versioned }
  end

  describe '.has_many' do
    it { is_expected.to have_many(:notifications).dependent(:restrict_with_error) }
  end
end
