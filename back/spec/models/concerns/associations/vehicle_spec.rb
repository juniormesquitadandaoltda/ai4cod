require 'rails_helper'

RSpec.describe Vehicle, type: :model do
  describe '.has_paper_trail' do
    it { is_expected.to be_versioned }

    it {
      expect(described_class.paper_trail_options[:only].map(&:to_sym)).to eq(%i[
        chassis
        year
        brand
        model
        color
        fuel
        category
        kind
        seats
        plate
        renavam
        licensing
      ])
    }
  end

  describe '.belongs_to' do
    it { is_expected.to belong_to(:subscription).counter_cache.required }
  end

  describe '.has_many' do
    it { is_expected.to have_many(:tasks).dependent(:restrict_with_error) }
  end

  describe '.has_many_attached' do
    it { is_expected.to have_many_attached(:archives) }
  end
end
