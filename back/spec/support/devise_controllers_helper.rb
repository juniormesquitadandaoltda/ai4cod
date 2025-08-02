require 'rspec/expectations'

RSpec.configure do |config|
  config.include Devise::Test::ControllerHelpers, type: :controller
end
