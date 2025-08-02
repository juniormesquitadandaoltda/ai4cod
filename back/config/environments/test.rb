require 'active_support/core_ext/integer/time'
require_relative '../../app/services/application_service'
require_relative '../../app/services/log_formatter_service'

Rails.application.configure do
  config.cache_classes = true

  config.eager_load = ENV['CI'] == 'TRUE'

  config.public_file_server.enabled = true
  config.public_file_server.headers = {
    'Cache-Control' => "public, max-age=#{1.hour.to_i}"
  }

  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false
  config.cache_store = :null_store

  config.action_dispatch.show_exceptions = false

  config.action_controller.allow_forgery_protection = false

  config.active_storage.service = :test

  config.action_mailer.merge!(
    perform_caching: false,
    delivery_method: :test,
    perform_deliveries: false,
    default_url_options: {
      host: 'localhost',
      port: '4000',
      protocol: 'http'
    }
  )

  config.active_support.deprecation = :stderr

  config.active_support.disallowed_deprecation = :raise

  config.active_support.disallowed_deprecation_warnings = []

  config.i18n.raise_on_missing_translations = true

  config.action_view.annotate_rendered_view_with_filenames = true

  config.active_job.queue_adapter = :test

  config.log_level = :debug

  if ENV['LOG'] == 'TRUE'
    logger           = ActiveSupport::Logger.new($stdout)
    logger.formatter = config.log_formatter
    config.logger    = ActiveSupport::TaggedLogging.new(logger)
  end

  config.active_storage.variant_records_enabled = false
  config.active_storage.analyzers = []
  config.active_storage.previewers = []
  config.active_storage.service_urls_expire_in = 1.minute
end
