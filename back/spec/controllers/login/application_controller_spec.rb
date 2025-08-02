require 'rails_helper'

module Login
  RSpec.describe ApplicationController, type: :controller do
    render_views

    it '.responder' do
      expect(described_class.responder).to eq(::BaseResponder)
    end

    describe '.rescue_from' do
      it { is_expected.to rescue_from(::Login::UnauthorizedException).with(:unauthorized) }
      it { is_expected.to rescue_from(::ActionController::UnknownFormat).with(:not_found) }
      it { is_expected.to rescue_from(::ActionController::InvalidAuthenticityToken).with(:unprocessable_entity) }
      it { is_expected.to rescue_from(SkipRedirectsException).with(:respond_with) }
    end

    describe '.around_action' do
      it { is_expected.to use_around_action(:set_timezone) }
      it { is_expected.to use_around_action(:set_locale) }
    end

    describe '.after_action' do
      it { is_expected.to use_after_action(:set_new_relic_controller) }
    end

    it '#current_user' do
      user = create(:user)
      expect(subject.instance_variable_get(:@personification)).to eq(nil)

      subject.session[:personification_id] = user.id
      subject.current_user

      expect(subject.instance_variable_get(:@personification)).to eq(user)
    end

    describe '#authenticate_user!' do
      let(:opts) { { scope: :user } }

      it 'must be success' do
        current_user = instance_double(User)

        expect(subject.warden).to receive(:authenticate!).with(opts) do
          subject.instance_variable_set(:@current_user, current_user)
        end

        subject.send(:authenticate_user!)

        expect(subject.current_user).to eq(current_user)
      end

      it 'must be fail' do
        expect(subject.warden).to receive(:authenticate!).with(opts) do
          subject.instance_variable_set(:@current_user, nil)
          throw(:warden)
        end

        expect do
          subject.send(:authenticate_user!)
        end.to raise_exception(UnauthorizedException)
      end
    end

    describe '#after_sign_in_path_for' do
      let(:resource) { create(:user) }

      it 'must be json' do
        request.format = :json

        expect do
          subject.send(:after_sign_in_path_for, resource)
        end.to raise_exception(SkipRedirectsException)
      end
    end

    describe '#after_sign_out_path_for' do
      let(:resource) { create(:user) }

      it 'must be json' do
        request.format = :json

        expect do
          subject.send(:after_sign_out_path_for, resource)
        end.to raise_exception(SkipRedirectsException)
      end
    end

    describe '#set_timezone' do
      let(:block) { proc { true } }

      it 'must be brasilia' do
        expect(subject).to receive(:current_user) { build(:user, timezone: :Brasilia) }

        expect(Time).to receive(:use_zone).with('Brasilia', &block)

        expect(subject.send(:set_timezone, &block)).to be_truthy
      end

      it 'must be utc' do
        expect(subject).to receive(:current_user) { build(:user, timezone: :UTC) }

        expect(Time).to receive(:use_zone).with('UTC', &block)

        expect(subject.send(:set_timezone, &block)).to be_truthy
      end
    end

    describe '#set_locale' do
      let(:block) { proc { true } }

      it 'must be en' do
        expect(subject).to receive(:current_user) { build(:user, locale: :en) }

        expect(I18n).to receive(:with_locale).with('en', &block)

        expect(subject.send(:set_locale, &block)).to be_truthy
      end

      it 'must be pt-BR' do
        expect(subject).to receive(:current_user) { build(:user, locale: :'pt-BR') }

        expect(I18n).to receive(:with_locale).with('pt-BR', &block)

        expect(subject.send(:set_locale, &block)).to be_truthy
      end
    end

    describe '#unauthorized' do
      it 'must by json with alert' do
        request.format = :json
        flash.alert = 'error'

        expect(subject).to receive(:render).with(json: {
                                                   alert: flash.alert,
                                                   redirect: new_login_session_path,
                                                   locale: I18n.locale,
                                                   timezone: Time.zone.name
                                                 }, status: :unauthorized)

        subject.send(:unauthorized)
      end

      it 'must by json with default' do
        request.format = :json

        expect(subject).to receive(:render).with(json: {
                                                   alert: I18n.t!('login.failure.unauthorized'),
                                                   redirect: new_login_session_path,
                                                   locale: I18n.locale,
                                                   timezone: Time.zone.name
                                                 }, status: :unauthorized)

        subject.send(:unauthorized)
      end
    end

    describe '#not_found' do
      it 'must by json with alert' do
        request.format = :json
        flash.alert = 'error'

        expect(subject).to receive(:render).with(json: {
                                                   alert: flash.alert,
                                                   locale: I18n.locale,
                                                   timezone: Time.zone.name
                                                 }, status: :not_found)

        subject.send(:not_found)
      end

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

    describe '#unprocessable_entity' do
      it 'must by json with alert' do
        request.format = :json
        flash.alert = 'error'

        expect(subject).to receive(:render).with(json: {
                                                   alert: flash.alert,
                                                   locale: I18n.locale,
                                                   timezone: Time.zone.name
                                                 }, status: :unprocessable_entity)

        subject.send(:unprocessable_entity)
      end

      it 'must by json with default' do
        request.format = :json

        expect(subject).to receive(:render).with(json: {
                                                   alert: I18n.t!('login.failure.unprocessable_entity'),
                                                   locale: I18n.locale,
                                                   timezone: Time.zone.name
                                                 }, status: :unprocessable_entity)

        subject.send(:unprocessable_entity)
      end
    end

    it '#_wrapper_key' do
      expect(subject.send(:_wrapper_key)).to eq('user')
    end

    it '#set_new_relic_controller' do
      segment = instance_double(::NewRelic::Agent::Transaction::Segment)

      expect(::NewRelic::Agent::Tracer).to receive(:current_segment) { segment }
      expect(segment).to receive(:instance_variable_set).with(:@controller, subject)

      subject.send(:set_new_relic_controller)
    end
  end
end
