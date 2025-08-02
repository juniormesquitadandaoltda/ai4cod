require 'rails_helper'

RSpec.describe Archive, type: :model do
  describe '.has_paper_trail' do
    it { is_expected.not_to be_versioned }
  end

  describe '.belongs_to' do
    it { is_expected.to belong_to(:subscription).counter_cache(:archives_count) }
  end
end
