require 'rails_helper'

RSpec.describe Notificator, type: :model do
  describe '#name' do
    it { is_expected.to validate_presence_of(:name) }

    it { expect(create(:notificator)).to validate_uniqueness_of(:name).case_insensitive }
  end

  describe '#token' do
    before { allow_any_instance_of(described_class).to receive(:config_token!) }

    it { is_expected.to validate_presence_of(:token) }

    it { expect(create(:notificator, token: 'token')).to validate_uniqueness_of(:token).case_insensitive }
  end

  it '#config_token!' do
    token = Devise.friendly_token(256)

    expect(Devise).to receive(:friendly_token) { token }
    subject.send(:config_token!)

    expect(subject.token).to eq(token)
  end

  it '#searchable_attributes' do
    expect(subject.send(:searchable_attributes)).to eq(%i[name])
  end

  describe '#actived' do
    it { is_expected.not_to validate_presence_of(:actived) }
  end

  describe '#counters' do
    it { expect(subject.notifications_count).to eq(0) }
  end
end
