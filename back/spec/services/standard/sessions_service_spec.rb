require 'rails_helper'

RSpec.describe STANDARD::SessionsService, type: :service do
  describe '.delegate' do
    it { is_expected.to delegate_method(:id).to(:subscription).with_prefix.allow_nil }
  end

  describe '#user' do
    it { is_expected.to validate_presence_of(:user) }

    it do
      expect(
        described_class.new(user: create(:user))
      ).to validate_persistence_of(:user)
    end
  end

  describe '#call' do
    let(:attributes) { { subscription: { id: '' } } }

    it 'must be valid' do
      service = described_class.new(user: create(:user))

      expect(service).to receive(:run).with(attributes).and_return(true)

      expect(service.call(attributes)).to be_truthy
    end

    it 'must be invalid' do
      expect(subject).not_to receive(:run)

      expect(subject.call).to be_falsey
      expect(subject.errors.details[:user]).to be_include(error: :blank)
    end

    it 'must be invalid by run' do
      service = described_class.new(user: create(:user))

      class << service
        def run(_attributes)
          errors.add(:base, 'message')
        end
      end

      expect(service.call(attributes)).to be_falsey
      expect(service.errors.details[:base]).to be_include(error: 'message')
    end
  end

  describe '#run' do
    let(:subscription) { create(:subscription) }

    it 'must be valid by id empty' do
      expect(subject).not_to receive(:valid_subscription?)

      expect(subject.send(:run, subscription: { id: '' })).to be_truthy
    end

    it 'must be valid by id exists' do
      expect(subject).to receive(:valid_subscription?).with(subscription.id).and_return(true)

      expect(subject.send(:run, subscription: { id: subscription.id })).to be_truthy
    end

    it 'must be invalid by id' do
      expect(subject).to receive(:valid_subscription?).with(0).and_return(false)

      expect(subject.send(:run, subscription: { id: 0 })).to be_falsey

      expect(subject.errors.details[:subscription]).to be_include(error: :invalid)
    end
  end

  it '#subscriptions' do
    subscription = create(:subscription)
    subject.assign_attributes(user: subscription.user, subscription:)

    create(:collaborator)
    create(:subscription, user: create(:user))

    expect(subject.subscriptions).to eq([subscription])
  end

  describe '#valid_subscription?' do
    it 'must be valid by subscription' do
      subject.user = create(:user)
      subject.subscription = create(:subscription, user: subject.user)

      expect(subject.send(:valid_subscription?, subject.subscription.id)).to be_truthy
    end

    it 'must be valid by collaborator' do
      subject.user = create(:user)
      subject.subscription = create(:subscription, user: create(:user))
      create(:collaborator, subscription: subject.subscription, user: subject.user)

      expect(subject.send(:valid_subscription?, subject.subscription.id)).to be_truthy
    end

    it 'must be invalid by id' do
      subject.user = create(:user)
      subject.subscription = create(:subscription)

      expect(subject.send(:valid_subscription?, 0)).to be_falsey
    end

    it 'must be invalid by subscription' do
      subject.user = create(:user)
      subject.subscription = create(:subscription, user: create(:user))

      expect(subject.send(:valid_subscription?, subject.subscription.id)).to be_falsey
    end

    it 'must be invalid by collaborator' do
      subject.user = create(:user)
      subject.subscription = create(:subscription, user: create(:user))
      create(:collaborator, subscription: subject.subscription, actived: false)

      subject.valid?

      expect(subject.send(:valid_subscription?, subject.subscription.id)).to be_falsey
    end
  end
end
