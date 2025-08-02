require 'rails_helper'

module Login
  RSpec.describe RegistrationsController, type: :controller do
    render_views

    before { request.env['devise.mapping'] = Devise.mappings[:user] }

    describe '.before_action' do
      it { is_expected.to use_before_action(:configure_account_update_params) }
    end

    describe '#after_update_path_for' do
      let(:resource) { create(:user) }

      it 'must be json' do
        request.format = :json

        expect do
          subject.send(:after_update_path_for, resource)
        end.to raise_exception(SkipRedirectsException)
      end
    end

    it '#set_flash_message!' do
      request.format = :json

      subject.send(:set_flash_message!, :notice, 'updated')

      expect(subject).to set_flash.now[:notice].to(
        I18n.t!('login.registrations.updated')
      )
    end
  end
end
