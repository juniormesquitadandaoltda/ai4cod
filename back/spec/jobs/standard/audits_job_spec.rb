require 'rails_helper'

module STANDARD
  RSpec.describe AuditsJob, type: :job do
    let!(:audit) { create(:audit) }
    let!(:whodunnit) { create(:user) }

    it '#perform' do
      service = instance_double(AuditsService, call: true)

      expect(AuditsService).to receive(:new).with(
        audit:
      ) { service }

      expect(subject.perform(audit:, whodunnit:)).to be_truthy
    end

    it '.perform_later' do
      expect do
        described_class.perform_later(audit:, whodunnit:)
      end.to have_enqueued_job.on_queue(:standard).exactly(:once)
    end
  end
end
