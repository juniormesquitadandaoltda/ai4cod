require 'rails_helper'

module PUBLIC
  RSpec.describe NotificationsController, type: :controller do
    render_views

    describe '.constants' do
      it { expect(described_class::MODEL).to eq(::Notification) }
    end

    describe '.before_action' do
      it { is_expected.to use_before_action(:set_notificator!) }
    end

    describe 'POST create' do
      let(:notificator) { create(:notificator) }

      it '.json success' do
        post :create, params: { notificator_token: notificator.token, key: 'value' }, format: :json

        expect(assigns(:model)).to be_a(described_class::MODEL)
        expect(response).to render_template(:create)
        expect(response).to have_http_status(:ok)
      end

      it '.json error' do
        post :create, params: { notificator_token: notificator.token }, format: :json

        expect(assigns(:model)).to be_a(described_class::MODEL)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    describe '#set_notificator!' do
      let(:notificator) { create(:notificator) }

      it 'must find' do
        subject.params = { notificator_token: notificator.token }

        expect(subject.send(:set_notificator!)).to eq(notificator)

        expect(assigns(:notificator)).to eq(notificator)
      end

      it 'not must find' do
        subject.params = { notificator_token: notificator.token.reverse }

        expect { subject.send(:set_notificator!) }.to raise_exception(::ActiveRecord::RecordNotFound)
      end
    end

    it '#model_params' do
      notificator = create(:notificator)

      request.headers[:HTTP_HOST] = 'host'
      request.request_parameters = { key: 'value' }
      subject.params.merge!(notificator_token: notificator.token)

      subject.send(:set_notificator!)

      expect(subject.send(:model_params).as_json).to eq({
        url: 'http://host',
        headers: {
          'Content-Length': '0',
          Host: 'host',
          'User-Agent': 'Rails Testing'
        },
        body: {
          key: 'value'
        },
        notificator: notificator.reload
      }.as_json)
    end
  end
end
