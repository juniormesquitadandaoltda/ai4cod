require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

module AI4Cod
  class Application < Rails::Application
    # Use the responders controller from the responders gem
    # config.app_generators.scaffold_controller :responders_controller

    config.load_defaults 7.0

    config.time_zone = 'Brasilia'
    config.active_record.default_timezone = :local

    config.i18n.available_locales = %i[en pt-BR]
    config.i18n.default_locale = 'pt-BR'

    config.secret_key_base = ENV['SECRET_KEY_BASE']

    config.generators do |g|
      g.assets false # create assets when generating a scaffold
      # g.force_plural false # allow pluralized model names
      g.helper false # generate helpers
      # g.integration_tool :test_unit # which tool generates integration tests (might be overwritten automatically if using rspec-rails)
      # g.system_tests :test_unit # which tool generates system tests (might be overwritten automatically if using rspec-rails)
      # g.orm false # which orm to use (false uses Active Record)
      # g.resource_controller :controller # which generator generates a controller when using bin/rails generate resource
      g.resource_route false # generate a resource route definition
      g.scaffold_controller false # which generator generates a controller when using bin/rails generate scaffold
      # g.stylesheets true # generate stylesheets
      # g.stylesheet_engine :css # configures the stylesheet engine (for e.g. sass) to be used when generating assets. Defaults to :css.
      # g.scaffold_stylesheet false # creates scaffold.css when generating a scaffolded resource. Defaults to true.
      # g.test_framework false # which test framework to use (false uses Minitest) (might be overwritten automatically if using rspec-rails)
      # g.template_engine :erb # which template engine to use
    end
  end
end
