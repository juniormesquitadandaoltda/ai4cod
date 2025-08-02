require 'rails_helper'

module PUBLIC
  RSpec.describe ApplicationController, type: :controller do
    render_views

    it '.responder' do
      expect(described_class.responder).to eq(::BaseResponder)
    end

    describe '.rescue_from' do
      it { is_expected.to rescue_from(::ActiveRecord::RecordNotFound).with(:not_found) }
    end

    describe '.before_action' do
      it { is_expected.to use_before_action(:log_headers!) }
      it { is_expected.to use_before_action(:verify_requested_format!) }
    end

    describe '.skipe_before_action' do
      it { is_expected.not_to use_before_action(:verify_authenticity_token) }
    end

    describe '.after_action' do
      it { is_expected.to use_after_action(:set_new_relic_controller) }
    end

    describe '#not_found' do
      it 'must by json with default' do
        request.format = :json

        expect(subject).to receive(:render).with(json: {
                                                   alert: I18n.t!('login.failure.not_found'),
                                                   locale: I18n.locale,
                                                   timezone: Time.zone.name
                                                 }, status: :not_found)

        subject.send(:not_found)
      end
    end

    it '#_wrapper_key' do
      expect(subject.send(:_wrapper_key)).to eq('model')
    end

    it '#set_new_relic_controller' do
      segment = instance_double(::NewRelic::Agent::Transaction::Segment)

      expect(::NewRelic::Agent::Tracer).to receive(:current_segment) { segment }
      expect(segment).to receive(:instance_variable_set).with(:@controller, subject)

      subject.send(:set_new_relic_controller)
    end
  end
end
