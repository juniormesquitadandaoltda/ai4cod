require 'base_responder'

module PUBLIC
  class ApplicationController < ::ActionController::Base
    self.responder = ::BaseResponder

    respond_to :json

    rescue_from ::ActiveRecord::RecordNotFound, with: :not_found

    before_action :log_headers!
    before_action :verify_requested_format!

    skip_before_action :verify_authenticity_token

    after_action :set_new_relic_controller

    private

    def log_headers!
      logger.info "  Headers: #{request.headers.to_h.select { |k, _v| (k.start_with?('HTTP_') || k.start_with?('CONTENT_')) && k.exclude?('_COOKIE') }.reduce({}) { |h, (k, v)| h.merge(k.gsub('HTTP_', '').titleize.gsub(' ', '-') => v) }.as_json}"
    end

    def not_found
      render json: {
        alert: I18n.t!('login.failure.not_found'),
        locale: I18n.locale,
        timezone: Time.zone.name
      }, status: :not_found
    end

    def _wrapper_key
      'model'
    end

    def set_new_relic_controller
      ::NewRelic::Agent::Tracer.current_segment.instance_variable_set(:@controller, self)
    end
  end
end
