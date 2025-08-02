require 'rspec/expectations'

RSpec.configure do |config|
  config.before :each, type: :controller do
    if controller.is_a?(ADMIN::ApplicationController)
      controller.instance_variable_set('@current_user', create(:user, :admin))

      allow(subject).to receive(:authorize_user!).and_wrap_original do |block|
        block.call
      rescue Pundit::NotAuthorizedError
        nil
      end
    end
  end
end
