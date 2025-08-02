require 'rails_helper'

module ADMIN
  RSpec.describe SubscriptionsController, type: :controller do
    render_views

    let(:model) do
      current = create(:subscription)
      current.fields.destroy_all
      current
    end

    describe '.constants' do
      it { expect(described_class::FILTER).to eq(SubscriptionsFilter) }
      it { expect(described_class::MODEL).to eq(::Subscription) }
    end

    describe '.before_action' do
      it { is_expected.to use_before_action(:set_model!) }
    end

    describe 'GET index' do
      it '.json success' do
        get :index, params: { sort: 'id', order: 'asc', page: 1, limit: 100 }, format: :json

        expect(assigns(:filter)).to be_a(described_class::FILTER)
        expect(response).to render_template(:index)
        expect(response).to have_http_status(:ok)
      end

      it '.json error' do
        get :index, params: {}, format: :json

        expect(assigns(:filter)).to be_a(described_class::FILTER)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    describe 'GET show' do
      it '.json success' do
        get :show, params: { id: model.id }, format: :json

        expect(assigns(:model)).to be_a(described_class::MODEL)
        expect(response).to render_template(:show)
        expect(response).to have_http_status(:ok)
      end

      it '.json not_found' do
        get :show, params: { id: 0 }, format: :json

        expect(response).to have_http_status(:not_found)
      end
    end

    describe 'GET new' do
      it '.json' do
        get :new, params: {}, format: :json

        expect(assigns(:model)).to be_nil
        expect(response).to render_template(:new)
        expect(response).to have_http_status(:ok)
      end
    end

    describe 'GET edit' do
      it '.json success' do
        get :edit, params: { id: model.id }, format: :json

        expect(assigns(:model)).to be_a(described_class::MODEL)
        expect(response).to render_template(:edit)
        expect(response).to have_http_status(:ok)
      end

      it '.json not_found' do
        get :edit, params: { id: 0 }, format: :json

        expect(response).to have_http_status(:not_found)
      end
    end

    describe 'POST create' do
      it '.json success' do
        attributes = attributes_for(:subscription)
        attributes.merge!(
          user: { uuid: attributes[:user].reload.uuid }
        )

        post :create, params: { model: attributes }, format: :json

        expect(assigns(:model)).to be_a(described_class::MODEL)
        expect(response).to render_template(:create)
        expect(response).to have_http_status(:ok)
      end

      it '.json error' do
        post :create, params: {}, format: :json

        expect(assigns(:model)).to be_a(described_class::MODEL)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    describe 'PUT update' do
      it '.json success' do
        put :update, params: { id: model.id }, format: :json

        expect(assigns(:model)).to be_a(described_class::MODEL)
        expect(response).to render_template(:update)
        expect(response).to have_http_status(:ok)
      end

      it '.json error' do
        put :update, params: { id: model.id, model: { name: nil } }, format: :json

        expect(assigns(:model)).to be_a(described_class::MODEL)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    describe 'DELETE destroy' do
      it '.json success' do
        delete :destroy, params: { id: model.id }, format: :json

        expect(assigns(:model)).to be_a(described_class::MODEL)
        expect(response).to render_template(:destroy)
        expect(response).to have_http_status(:ok)
      end

      it '.json unprocessable_entity' do
        create(:collaborator, subscription: model)

        delete :destroy, params: { id: model.id }, format: :json

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it '.json not_found' do
        delete :destroy, params: { id: 0 }, format: :json

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
        expect { subject.send(:set_model!) }.to raise_exception(::ActiveRecord::RecordNotFound)
      end
    end

    it '#filter_params' do
      subject.params = subject.send(:search_attributes, described_class::FILTER).each_with_index.to_h

      expect(subject.send(:filter_params).as_json).to eq(subject.params.merge(
        current_user: subject.current_user
      ).as_json)
    end

    it '#model_params' do
      attributes = { name: '', actived: '', user: { uuid: '' }, due_date: '', maximum_records_count: '' }

      subject.params = { model: attributes }

      expect(subject.send(:model_params).as_json).to eq(attributes.as_json)
    end
  end
end
