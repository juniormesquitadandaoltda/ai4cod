require 'rails_helper'

module ADMIN
  RSpec.describe ApplicationController, type: :controller do
    render_views

    it '.responder' do
      expect(described_class.responder).to eq(::BaseResponder)
    end

    describe '.rescue_from' do
      it { is_expected.to rescue_from(::Login::UnauthorizedException).with(:unauthorized) }
      it { is_expected.to rescue_from(::ActionController::UnknownFormat).with(:not_found) }
      it { is_expected.to rescue_from(::Pundit::NotAuthorizedError).with(:not_found) }
      it { is_expected.to rescue_from(::ActiveRecord::RecordNotFound).with(:not_found) }
      it { is_expected.to rescue_from(::ActionController::InvalidAuthenticityToken).with(:unprocessable_entity) }
    end

    describe '.before_action' do
      it { is_expected.to use_before_action(:verify_requested_format!) }
      it { is_expected.to use_before_action(:authenticate_user!) }
      it { is_expected.to use_before_action(:authorize_user!) }
      it { is_expected.to use_before_action(:set_paper_trail_whodunnit) }
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
        end.to raise_exception(::Login::UnauthorizedException)
      end
    end

    it '#pundit_user' do
      subject.params = { controller: 'controller', action: 'action', format: 'format', id: 0 }

      expect(subject.send(:pundit_user)).to eq(
        user: subject.current_user,
        params: { id: 0 }
      )
    end

    it '#authorize_user!' do
      expect(subject).to receive(:controller_path).and_return('controller')
      expect(subject).to receive(:action_name).and_return('action')

      expect(subject).to receive(:authorize).with(:controller, :action)

      subject.send(:authorize_user!)
    end

    it '#user_for_paper_trail' do
      expect(subject.send(:user_for_paper_trail)).to eq(subject.current_user)
    end

    describe '#set_timezone' do
      let(:block) { proc { true } }

      it 'must be brasilia' do
        subject.current_user.timezone = :Brasilia

        expect(Time).to receive(:use_zone).with('Brasilia', &block)

        expect(subject.send(:set_timezone, &block)).to be_truthy
      end

      it 'must be utc' do
        subject.current_user.timezone = :UTC

        expect(Time).to receive(:use_zone).with('UTC', &block)

        expect(subject.send(:set_timezone, &block)).to be_truthy
      end
    end

    describe '#set_locale' do
      let(:block) { proc { true } }

      it 'must be en' do
        subject.current_user.locale = :en

        expect(I18n).to receive(:with_locale).with('en', &block)

        expect(subject.send(:set_locale, &block)).to be_truthy
      end

      it 'must be pt-BR' do
        subject.current_user.locale = :'pt-BR'

        expect(I18n).to receive(:with_locale).with('pt-BR', &block)

        expect(subject.send(:set_locale, &block)).to be_truthy
      end
    end

    it '#search_attributes' do
      expect(subject.send(:search_attributes, WebhooksFilter)).to eq(%i[
        url
        url_in
        subscription_name
        subscription_name_in
        resource
        event
        actived
        subscription_id
        id
        created_at
        created_at_gt
        created_at_gte
        created_at_lt
        created_at_lte
        updated_at
        updated_at_gt
        updated_at_gte
        updated_at_lt
        updated_at_lte
        sort
        order
        page
        limit
      ])
    end

    it '#flash_interpolation_options' do
      model = instance_double(User, errors: { base: %w[error1 error2] })

      subject.instance_variable_set(:@model, model)

      expect(subject.send(:flash_interpolation_options)).to eq(
        destroy_alert: 'error1'
      )
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
