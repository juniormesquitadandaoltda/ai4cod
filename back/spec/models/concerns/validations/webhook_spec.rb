require 'rails_helper'

RSpec.describe Webhook, type: :model do
  describe '.enum' do
    it {
      expect(subject).to define_enum_for(:resource).with_values(
        %i[collaborator].reduce({}) { |h, v| h.merge!(v => v.to_s) }
      ).with_prefix.backed_by_column_of_type('string')
    }

    it {
      expect(subject).to define_enum_for(:event).with_values(
        %i[create update destroy].reduce({}) { |h, v| h.merge!(v => v.to_s) }
      ).with_prefix.backed_by_column_of_type('string')
    }
  end

  describe '#resource' do
    it { is_expected.to validate_presence_of(:resource) }
    it { expect(create(:webhook)).to validate_enum_of(:resource) }
  end

  describe '#event' do
    it { is_expected.to validate_presence_of(:event) }
    it { expect(create(:webhook)).to validate_enum_of(:event) }
  end

  describe '#url' do
    it { is_expected.to validate_presence_of(:url) }

    it { expect(create(:webhook)).to validate_uniqueness_of(:url).scoped_to(:event, :subscription_id).case_insensitive }
  end

  describe '#subscription' do
    it { is_expected.to validate_presence_of(:subscription) }

    it { expect(create(:webhook)).to validate_persistence_of(:subscription) }

    it { expect(create(:webhook)).to validate_unchange_of(:subscription) }
  end

  describe '#actived' do
    it { is_expected.not_to validate_presence_of(:actived) }
  end

  it '#searchable_attributes' do
    expect(subject.send(:searchable_attributes)).to eq(%i[url])
  end

  describe '#jsonb' do
    it { expect(subject.request_metadata).to eq({}) }
  end
end
