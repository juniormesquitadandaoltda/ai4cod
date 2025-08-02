require 'rails_helper'

module Login
  RSpec.describe UnlocksController, type: :controller do
    render_views

    before { request.env['devise.mapping'] = Devise.mappings[:user] }

    describe 'GET edit' do
      it '.json ok' do
        get :edit, params: { unlock_token: 'unlock_token' }, format: :json

        expect(response).to render_template(:edit)
        expect(response).to have_http_status(:ok)
      end
    end

    describe '#successfully_sent?' do
      let(:resource) { build(:user) }

      it 'must be successful' do
        expect(subject.send(:successfully_sent?, resource)).to be_truthy
      end

      it 'must be fail' do
        resource.email = nil

        expect(subject.send(:successfully_sent?, resource)).to be_falsey
      end
    end

    describe '#after_sending_unlock_instructions_path_for' do
      let(:resource) { create(:user) }

      it 'must be json' do
        request.format = :json

        expect do
          subject.send(:after_sending_unlock_instructions_path_for, resource)
        end.to raise_exception(SkipRedirectsException)
      end
    end

    describe '#after_unlock_path_for' do
      let(:resource) { create(:user) }

      it 'must be json' do
        request.format = :json

        expect do
          subject.send(:after_unlock_path_for, resource)
        end.to raise_exception(SkipRedirectsException)
      end
    end

    it '#set_flash_message!' do
      request.format = :json

      subject.send(:set_flash_message!, :alert, 'unlocked')

      expect(subject).to set_flash.now[:alert].to(
        I18n.t!('login.unlocks.unlocked')
      )
    end
  end
end
