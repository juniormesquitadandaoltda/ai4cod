RSpec.configure do |config|
  config.before do
    allow(ActiveStorage::Current).to receive(:url_options) do
      Rails.application.config.action_mailer.default_url_options
    end
  end
end
