require 'rails_helper'

module ADMIN
  RSpec.describe SwaggerController, type: :controller do
    render_views

    describe 'GET show' do
      it '.json login' do
        get :show, params: { version: 'v1', file: 'login' }, format: :json

        expect(response).to render_template(:show)
        expect(response).to have_http_status(:ok)
      end

      it '.json user' do
        get :show, params: { version: 'v1', file: 'standard' }, format: :json

        expect(response).to render_template(:show)
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
