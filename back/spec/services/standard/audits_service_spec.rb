require 'rails_helper'

module STANDARD
  RSpec.describe AuditsService, type: :service do
    describe '#audit' do
      it { is_expected.to validate_presence_of(:audit) }

      it do
        expect(
          described_class.new(audit: create(:audit))
        ).to validate_persistence_of(:audit)
      end
    end

    describe '#call' do
      let(:attributes) { { audit: create(:audit) } }

      it 'must be valid' do
        service = described_class.new(attributes)

        expect(service).to receive(:run).and_return(true)

        expect(service.call).to be_truthy
      end

      it 'must be invalid' do
        expect(subject).not_to receive(:run)

        expect(subject.call).to be_falsey
        expect(subject.errors.details[:audit]).to be_include(error: :blank)
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
      webhook = create(:webhook)
      expect(subject).to receive(:webhooks) { ::Webhook.all }

      expect(subject).to receive(:request).with(webhook)

      expect(subject.send(:run)).to be_truthy
    end

    it '#webhooks' do
      webhook_1 = create(:webhook, event: :create)
      audit = create(:audit,
                     item: webhook_1, event: :create, whodunnit: webhook_1.subscription.user)
      subject.assign_attributes(audit:)

      webhook_2 = create(:webhook, event: :create, subscription: create(:subscription, user: create(:user)))
      create(:audit,
             item: webhook_2, event: :create, whodunnit: webhook_2.subscription.user)

      expect(subject.send(:webhooks)).to eq([webhook_1])
    end

    it '#request' do
      webhook = create(:webhook)

      expect(subject).to receive(:body).with(webhook).and_return({})
      expect(subject).to receive(:post).with(url: webhook.url, body: {}).and_return(200)
      expect(subject).to receive(:update).with(webhook:, body: {}, status: 200).and_return(true)

      subject.send(:request, webhook)
    end

    it '#body' do
      webhook = create(:webhook)
      subject.audit = create(:audit)

      expect(subject.send(:body, webhook)).to eq(
        resource: webhook.resource,
        event: webhook.event,
        idempotent: subject.audit.id,
        id: subject.audit.item_id
      )
    end

    it '#post' do
      faraday = instance_double(::Faraday.new.class)

      expect(::Faraday).to receive(:new).with(request: { timeout: 1 }) { faraday }
      expect(faraday).to receive(:post).with('url', '{}', {
                                               user_agent: 'AI for Code .COM',
                                               accept: 'application/json',
                                               content_type: 'application/json'
                                             }) { instance_double(::Faraday::Response, status: 200) }

      subject.send(:post, url: 'url', body: {})
    end

    describe '#update' do
      it 'must be actived' do
        Timecop.freeze do
          webhook = create(:webhook)

          subject.send(:update, webhook:, body: { key: 'value' }, status: 200)

          expect(webhook.as_json).to include_json(
            request_metadata: {
              url: webhook.url,
              body: { key: 'value' },
              status: 200
            },
            requested_at: Time.current.as_json,
            actived: true,
            requests_count: 1
          )
        end
      end

      it 'must be inactive' do
        Timecop.freeze do
          webhook = create(:webhook)

          subject.send(:update, webhook:, body: { key: 'value' }, status: 300)

          expect(webhook.as_json).to include_json(
            request_metadata: {
              url: webhook.url,
              body: { key: 'value' },
              status: 300
            },
            requested_at: Time.current.as_json,
            actived: false,
            requests_count: 1
          )
        end
      end
    end
  end
end
