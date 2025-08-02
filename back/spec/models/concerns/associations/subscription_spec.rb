require 'rails_helper'

RSpec.describe Subscription, type: :model do
  describe '.has_paper_trail' do
    it { is_expected.to be_versioned }
  end

  describe '.belongs_to' do
    it { is_expected.to belong_to(:user).counter_cache.required }
  end

  describe '.has_many' do
    it { is_expected.to have_many(:calleds).dependent(:restrict_with_error) }
    it { is_expected.to have_many(:webhooks).dependent(:restrict_with_error) }
    it { is_expected.to have_many(:collaborators).dependent(:restrict_with_error) }
    it { is_expected.to have_many(:fields).dependent(:restrict_with_error) }
    it { is_expected.to have_many(:proprietors).dependent(:restrict_with_error) }
    it { is_expected.to have_many(:facilitators).dependent(:restrict_with_error) }
    it { is_expected.to have_many(:vehicles).dependent(:restrict_with_error) }
    it { is_expected.to have_many(:tasks).dependent(:restrict_with_error) }
    it { is_expected.to have_many(:archives).dependent(:restrict_with_error) }
  end

  describe '.delegate' do
    it { is_expected.to delegate_method(:uuid).to(:user).allow_nil.with_prefix }
  end
end
