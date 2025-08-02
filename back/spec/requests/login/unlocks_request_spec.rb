require 'rails_helper'

module Login
  RSpec.describe UnlocksController, type: :request do
    let(:user) { create(:user) }

    let(:unlock_token) { user.send_unlock_instructions }

    it 'GET new' do
      get new_login_unlock_path(format: :json, full_path: true)

      expect(response).to have_http_status(:ok)
    end

    it 'GET edit' do
      get edit_login_unlock_path(format: :json, full_path: true)

      expect(response).to have_http_status(:ok)
    end

    describe 'POST create' do
      it '.json with success' do
        post login_unlock_path(format: :json, full_path: true), params: { user: { email: user.email } }

        expect(response).to have_http_status(:ok)
      end
    end

    describe 'PUT update' do
      it '.json with success' do
        put login_unlock_path(format: :json, full_path: true), params: { user: { unlock_token: } }

        expect(response).to have_http_status(:ok)
      end

      it '.json with errors' do
        put login_unlock_path(format: :json, full_path: true), params: { user: { unlock_token: unlock_token.reverse } }

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
