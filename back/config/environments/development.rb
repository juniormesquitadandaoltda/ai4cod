require 'active_support/core_ext/integer/time'
require_relative '../../app/services/application_service'
require_relative '../../app/services/log_formatter_service'

Rails.application.configure do
  config.cache_classes = false

  config.eager_load = false

  config.server_timing = true

  if Rails.root.join('tmp/caching-dev.txt').exist?
    config.action_controller.perform_caching = true
    config.action_controller.enable_fragment_cache_logging = true

    config.cache_store = :memory_store
    config.public_file_server.headers = {
      'Cache-Control' => "public, max-age=#{2.days.to_i}"
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

  config.active_storage.service = :localstack

  config.action_mailer.raise_delivery_errors = false

  config.action_mailer.perform_caching = false

  config.active_support.deprecation = :log

  config.active_support.disallowed_deprecation = :raise

  config.active_support.disallowed_deprecation_warnings = []

  config.active_record.migration_error = :page_load

  config.active_record.verbose_query_logs = true

  # config.assets.quiet = true

  config.i18n.raise_on_missing_translations = true

  config.action_view.annotate_rendered_view_with_filenames = true

  config.action_mailer.merge!(
    delivery_method: :letter_opener_web,
    perform_deliveries: true,
    default_url_options: {
      host: 'localhost',
      port: '4004',
      protocol: 'http'
    }
  )

  config.active_job.queue_adapter = :async
  config.active_job.queue_name_prefix = 'ai4cod'

  # config.hosts = ActionDispatch::HostAuthorization::ALLOWED_HOSTS_IN_DEVELOPMENT + %w[.dockerhost]
  config.hosts << '.dockerhost'
  config.action_controller.forgery_protection_origin_check = false
  config.action_cable.disable_request_forgery_protection = true
  config.consider_all_requests_local = true

  config.log_level = :debug
  # config.log_formatter = LogFormatterService.new
  logger = ActiveSupport::Logger.new($stdout)
  logger.formatter = config.log_formatter
  config.logger = ActiveSupport::TaggedLogging.new(logger)

  config.active_storage.variant_records_enabled = false
  config.active_storage.analyzers = []
  config.active_storage.previewers = []
  config.active_storage.service_urls_expire_in = 1.minute
end
