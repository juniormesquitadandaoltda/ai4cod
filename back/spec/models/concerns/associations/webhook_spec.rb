require 'rails_helper'

RSpec.describe Webhook, type: :model do
  describe '.has_paper_trail' do
    it { is_expected.to be_versioned }

    it {
      expect(described_class.paper_trail_options[:only].map(&:to_sym)).to eq(%i[
        url
        actived
        resource event
      ])
    }
  end

  describe '.belongs_to' do
    it { is_expected.to belong_to(:subscription).counter_cache.required }
  end
end
