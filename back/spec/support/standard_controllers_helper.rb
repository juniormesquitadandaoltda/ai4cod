require 'rspec/expectations'

RSpec.configure do |config|
  config.before :each, type: :controller do
    if controller.is_a?(STANDARD::ApplicationController)
      subscription = create(:subscription).reload
      controller.instance_variable_set('@current_user', subscription.user)
      controller.instance_variable_set('@current_subscription', subscription)
      controller.instance_variable_set('@current_client', subscription)

      allow(subject).to receive(:authorize_user!).and_wrap_original do |block|
        block.call
      rescue Pundit::NotAuthorizedError
        nil
      end
    end
  end
end
