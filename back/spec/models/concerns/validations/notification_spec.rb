require 'rails_helper'

RSpec.describe Notification, type: :model do
  describe '#url' do
    it { is_expected.to validate_presence_of(:url) }
  end

  describe '#headers' do
    it { is_expected.to validate_presence_of(:headers) }
  end

  describe '#body' do
    it { is_expected.to validate_presence_of(:body) }
  end

  describe '#notificator' do
    it { is_expected.to validate_presence_of(:notificator) }

    it { expect(create(:notification)).to validate_persistence_of(:notificator) }

    it { expect(create(:notification)).to validate_unchange_of(:notificator) }
  end

  it '#searchable_attributes' do
    expect(subject.send(:searchable_attributes)).to eq([])
  end

  describe '#jsonb' do
    it { expect(subject.headers).to eq({}) }
    it { expect(subject.body).to eq({}) }
  end
end
