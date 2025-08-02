require 'rails_helper'

module Login
  RSpec.describe RegistrationsController, type: :request do
    let(:user) { create(:user) }

    it 'GET edit' do
      put login_session_path(format: :json, full_path: true), params: { user: { email: user.email, policy_terms: true } }
      post login_session_path(format: :json, full_path: true), params: { user: { email: user.email, password: user.generate_temp_password, remember_me: true } }

      get edit_login_registration_path(format: :json, full_path: true)

      expect(response).to have_http_status(:ok)
    end

    describe 'PUT update' do
      it '.json with success' do
        put login_session_path(format: :json, full_path: true), params: { user: { email: user.email, policy_terms: true } }
        post login_session_path(format: :json, full_path: true), params: { user: { email: user.email, password: user.generate_temp_password, remember_me: true } }

        put login_registration_path(format: :json, full_path: true), params: { user: {
          name: user.name,
          timezone: user.timezone,
          locale: user.locale
        } }

        expect(response).to have_http_status(:ok)
      end

      it '.json with errors' do
        put login_session_path(format: :json, full_path: true), params: { user: { email: user.email, policy_terms: true } }
        post login_session_path(format: :json, full_path: true), params: { user: { email: user.email, password: user.generate_temp_password, remember_me: true } }

        put login_registration_path(format: :json, full_path: true), params: { user: {
          timezone: nil,
          locale: nil
        } }

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    describe 'DELETE destroy' do
      it '.json with success' do
        put login_session_path(format: :json, full_path: true), params: { user: { email: user.email, policy_terms: true } }
        post login_session_path(format: :json, full_path: true), params: { user: { email: user.email, password: user.generate_temp_password, remember_me: true } }

        delete login_registration_path(format: :json, full_path: true)

        expect(response).to have_http_status(:ok)
      end
    end
  end
end
