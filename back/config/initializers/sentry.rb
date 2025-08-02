if ENV['SENTRY_DSN']
  Sentry.init do |config|
    config.dsn = ENV['SENTRY_DSN']
    config.breadcrumbs_logger = %i[active_support_logger http_logger]

    config.enabled_environments = [Rails.env]
    config.environment = Rails.env
    config.release = ENV['GITHUB_RELEASE']

    # Set traces_sample_rate to 1.0 to capture 100%
    # of transactions for performance monitoring.
    # We recommend adjusting this value in production.
    config.traces_sample_rate = ENV['SENTRY_RATE'].to_f
    # config.sample_rate = ENV['SENTRY_RATE'].to_f
    # or
    # config.traces_sampler = lambda do |_context|
    #   true
    # end

    config.send_default_pii = true
  end
end
