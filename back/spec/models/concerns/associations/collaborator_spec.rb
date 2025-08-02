require 'rails_helper'

RSpec.describe Collaborator, type: :model do
  describe '.has_paper_trail' do
    it { is_expected.to be_versioned }
  end

  describe '.belongs_to' do
    it { is_expected.to belong_to(:user).counter_cache(:collaborations_count).required }
    it { is_expected.to belong_to(:subscription).counter_cache.required }
  end

  describe '.delegate' do
    it { is_expected.to delegate_method(:uuid).to(:user).allow_nil.with_prefix }
    it { is_expected.to delegate_method(:user).to(:subscription).allow_nil.with_prefix }
  end
end
