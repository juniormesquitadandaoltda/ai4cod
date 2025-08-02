require 'rails_helper'

module Login
  RSpec.describe SessionsController, type: :controller do
    render_views

    before { request.env['devise.mapping'] = Devise.mappings[:user] }

    describe '.before_action' do
      it { is_expected.to use_before_action(:configure_sign_up_params) }
      it { is_expected.to use_before_action(:configure_sign_in_params) }
    end

    it '#set_flash_message!' do
      request.format = :json

      subject.send(:set_flash_message!, :alert, 'locked')

      expect(subject).to set_flash.now[:alert].to(
        I18n.t!('login.sessions.locked')
      )
    end
  end
end
