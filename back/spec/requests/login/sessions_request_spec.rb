require 'rails_helper'

module Login
  RSpec.describe SessionsController, type: :request do
    let(:user) { create(:user) }

    it 'GET new' do
      get new_login_session_path(format: :json, full_path: true)

      expect(response).to have_http_status(:ok)
    end

    describe 'POST create' do
      it '.json with success' do
        put login_session_path(format: :json, full_path: true), params: { user: { email: user.email, policy_terms: true } }

        post login_session_path(format: :json, full_path: true), params: { user: { email: user.email, password: user.generate_temp_password, remember_me: true, policy_terms: true } }

        expect(response).to have_http_status(:ok)
      end

      it '.json with errors and invalid access_token' do
        put login_session_path(format: :json, full_path: true), params: { user: { email: user.email, policy_terms: true } }

        post login_session_path(format: :json, full_path: true), params: { user: { email: user.email, password: user.generate_temp_password.reverse, remember_me: true, policy_terms: true } }

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it '.json with errors' do
        put login_session_path(format: :json, full_path: true), params: { user: { email: user.email, policy_terms: true } }

        post login_session_path(format: :json, full_path: true), params: {}

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    describe 'POST put' do
      it '.json with success and persisted user' do
        user.confirm

        put login_session_path(format: :json, full_path: true), params: { user: { email: user.email, policy_terms: true } }

        expect(response).to have_http_status(:ok)
      end

      it '.json with success and new user' do
        put login_session_path(format: :json, full_path: true), params: { user: { email: user.email.reverse, policy_terms: true } }

        expect(response).to have_http_status(:ok)
      end

      it '.json with errors' do
        put login_session_path(format: :json, full_path: true), params: {}

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    describe 'DELETE destroy' do
      it '.json with success' do
        put login_session_path(format: :json, full_path: true), params: { user: { email: user.email } }
        post login_session_path(format: :json, full_path: true), params: { user: { email: user.email, password: user.generate_temp_password } }

        delete login_session_path(format: :json, full_path: true)

        expect(response).to have_http_status(:ok)
      end
    end
  end
end
