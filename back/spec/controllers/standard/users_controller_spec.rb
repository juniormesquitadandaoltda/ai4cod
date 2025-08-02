require 'rails_helper'

module STANDARD
  RSpec.describe UsersController, type: :controller do
    render_views

    describe '.constants' do
      it { expect(described_class::FILTER).to eq(UsersFilter) }
      it { expect(described_class::MODEL).to eq(::User) }
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

    it '#filter_params' do
      subject.params = subject.send(:search_attributes, described_class::FILTER).each_with_index.to_h

      expect(subject.send(:filter_params).as_json).to eq(subject.params.merge(
        current_user: subject.current_user,
        current_subscription: subject.send(:current_subscription)
      ).as_json)
    end
  end
end
