require 'active_support/core_ext/integer/time'
require_relative '../../app/services/application_service'
require_relative '../../app/services/log_formatter_service'

Rails.application.configure do
  config.cache_classes = true

  config.eager_load = true

  config.action_controller.perform_caching = true

  config.require_master_key = false

  # config.public_file_server.enabled = ENV['RAILS_SERVE_STATIC_FILES'] == 'true'
  config.public_file_server.enabled = true

  # config.assets.css_compressor = :sass

  # config.assets.compile = false

  # config.asset_host = '/'

  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect'
  config.action_dispatch.x_sendfile_header = nil

  config.active_storage.service = :amazon

  # config.force_ssl = true

  config.log_tags = [:request_id]

  config.active_job.queue_adapter = :sidekiq
  config.active_job.queue_name_prefix = 'ai4cod'

  config.i18n.fallbacks = true

  config.active_support.report_deprecations = false

  config.active_record.dump_schema_after_migration = false

  config.action_mailer.perform_caching = true
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.merge!(
    delivery_method: :smtp,
    perform_deliveries: true,
    default_url_options: {
      host: ENV['SMTP_DOMAIN'],
      port: '443',
      protocol: 'https'
    },
    smtp_settings: {
      address: ENV['SMTP_ADDRESS'],
      domain: ENV['SMTP_DOMAIN'],
      port: ENV['SMTP_PORT'],
      user_name: ENV['SMTP_USERNAME'],
      password: ENV['SMTP_PASSWORD'],
      authentication: :plain,
      enable_starttls_auto: true,
      tls: true
    }
  )

  # config.hosts = ActionDispatch::HostAuthorization::ALLOWED_HOSTS_IN_DEVELOPMENT + %w[.ai4cod.com]
  config.hosts.push(*ENV['ALLOWED_HOSTS'].to_s.split(',')) # .ai4cod.com,alb
  # config.host_authorization = { exclude: -> (r) { r.path == '/'} }
  config.action_controller.forgery_protection_origin_check = false
  config.action_cable.disable_request_forgery_protection = true
  config.consider_all_requests_local = false

  config.log_level = :info
  if ENV['RAILS_LOG_TO_STDOUT'] == 'true'
    config.log_formatter = LogFormatterService.new
    logger           = ActiveSupport::Logger.new($stdout)
    logger.formatter = config.log_formatter
    config.logger    = ActiveSupport::TaggedLogging.new(logger)
  end

  config.active_storage.variant_records_enabled = false
  config.active_storage.analyzers = []
  config.active_storage.previewers = []
  config.active_storage.service_urls_expire_in = 1.minute
end
