require 'rails_helper'

module STANDARD
  RSpec.describe AuditsController, type: :controller do
    render_views

    let(:model) { create(:audit, item: subject.send(:current_subscription)) }
    let(:other) { create(:audit, item: create(:subscription, user: create(:user))) }

    describe '.constants' do
      it { expect(described_class::FILTER).to eq(AuditsFilter) }
      it { expect(described_class::MODEL).to eq(::Audit) }
    end

    describe '.before_action' do
      it { is_expected.to use_before_action(:set_model!) }
    end

    describe 'GET index' do
      it '.json ok' do
        get :index, params: { sort: 'id', order: 'asc', page: 1, limit: 100 }, format: :json

        expect(assigns(:filter)).to be_a(described_class::FILTER)
        expect(response).to render_template(:index)
        expect(response).to have_http_status(:ok)
      end

      it '.json unprocessable_entity' do
        get :index, params: {}, format: :json

        expect(assigns(:filter)).to be_a(described_class::FILTER)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    describe 'GET show' do
      it '.json ok' do
        get :show, params: { id: model.id }, format: :json

        expect(assigns(:model)).to be_a(described_class::MODEL)
        expect(response).to render_template(:show)
        expect(response).to have_http_status(:ok)
      end

      it '.json not_found' do
        get :show, params: { id: other.id }, format: :json

        expect(response).to have_http_status(:not_found)
      end
    end

    describe '#set_model!' do
      it 'must find' do
        subject.params = { id: model.id }

        expect(subject.send(:set_model!)).to eq(model)

        expect(assigns(:model)).to be_a(described_class::MODEL)
      end

      it 'not must find' do
        subject.params = { id: other.id }

        expect { subject.send(:set_model!) }.to raise_exception(::ActiveRecord::RecordNotFound)
      end
    end

    it '#filter_params' do
      subject.params = subject.send(:search_attributes, described_class::FILTER).each_with_index.to_h

      expect(subject.send(:filter_params).as_json).to eq(subject.params.merge(
        current_user: subject.current_user,
        current_subscription: subject.send(:current_subscription)
      ).as_json)
    end
  end
end
