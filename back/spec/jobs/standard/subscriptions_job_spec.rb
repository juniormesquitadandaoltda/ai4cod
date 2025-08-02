require 'rails_helper'

module STANDARD
  RSpec.describe SubscriptionsJob, type: :job do
    let!(:subscription) { create(:subscription) }
    let!(:whodunnit) { create(:user) }

    it '#perform' do
      service = instance_double(SubscriptionsService, call: true)

      expect(SubscriptionsService).to receive(:new).with(
        subscription:
      ) { service }

      expect(subject.perform(subscription:, whodunnit:)).to be_truthy
    end

    it '.perform_later' do
      expect do
        described_class.perform_later(subscription:, whodunnit:)
      end.to have_enqueued_job.on_queue(:standard).exactly(:once)
    end
  end
end
