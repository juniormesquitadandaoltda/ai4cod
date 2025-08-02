require 'rails_helper'

module STANDARD
  RSpec.describe SubscriptionsService, type: :service do
    describe '#subscription' do
      it { is_expected.to validate_presence_of(:subscription) }

      it do
        expect(
          described_class.new(subscription: create(:subscription))
        ).to validate_persistence_of(:subscription)
      end
    end

    describe '#call' do
      let(:attributes) { { subscription: create(:subscription) } }

      it 'must be valid' do
        service = described_class.new(attributes)

        expect(service).to receive(:run).and_return(true)

        expect(service.call).to be_truthy
      end

      it 'must be invalid' do
        expect(subject).not_to receive(:run)

        expect(subject.call).to be_falsey
        expect(subject.errors.details[:subscription]).to be_include(error: :blank)
      end

      it 'must be invalid by run' do
        service = described_class.new(attributes)

        class << service
          def run
            errors.add(:base, 'message')
          end
        end

        expect(service.call).to be_falsey
        expect(service.errors.details[:base]).to be_include(error: 'message')
      end
    end

    it '#run' do
      expect(subject).to receive(:create_fields)

      expect(subject.send(:run)).to be_truthy
    end

    it '#create_fields' do
      subscription = create(:subscription)
      subscription.fields.destroy_all

      subject.subscription = subscription

      expect { subject.send(:create_fields) }.to change { subscription.fields.count }.from(0).to(7)
      expect { subject.send(:create_fields) }.not_to change { subscription.fields.count }.from(7)
    end
  end
end
