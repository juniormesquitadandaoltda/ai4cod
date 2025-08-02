require 'rails_helper'

module STANDARD
  RSpec.describe SubscriptionsController, type: :controller do
    render_views

    let(:model) { subject.current_subscription }

    describe '.constants' do
      it { expect(described_class::MODEL).to eq(::Subscription) }
    end

    describe 'GET show' do
      it '.json' do
        get :show, params: {}, format: :json

        expect(assigns(:model)).to be_a(described_class::MODEL)
        expect(response).to render_template(:show)
        expect(response).to have_http_status(:ok)
      end
    end

    describe '#set_model!' do
      it 'must find' do
        expect(subject.send(:set_model!)).to eq(model)

        expect(assigns(:model)).to be_a(described_class::MODEL)
      end
    end
  end
end
