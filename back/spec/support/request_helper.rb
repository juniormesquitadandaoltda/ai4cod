require 'rspec/expectations'

RSpec.configure do |config|
  config.before(:each, type: :request) do
    host! 'localhost'
  end
end
