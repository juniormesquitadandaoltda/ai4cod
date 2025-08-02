require 'base_responder'

module Login
  class ApplicationController < ::ActionController::Base
    MODEL = User

    self.responder = ::BaseResponder

    respond_to :json

    rescue_from UnauthorizedException, with: :unauthorized
    rescue_from ::ActionController::UnknownFormat, with: :not_found
    rescue_from ::ActionController::InvalidAuthenticityToken, with: :unprocessable_entity
    rescue_from SkipRedirectsException, with: :respond_with

    before_action :log_headers!

    around_action :set_timezone
    around_action :set_locale

    after_action :set_new_relic_controller

    def current_user
      if session[:personification_id]
        @personification ||= User.find(session[:personification_id])
      else
        super
      end
    end

    private

    def log_headers!
      logger.info "  Headers: #{request.headers.to_h.select { |k, _v| (k.start_with?('HTTP_') || k.start_with?('CONTENT_')) && k.exclude?('_COOKIE') }.reduce({}) { |h, (k, v)| h.merge(k.gsub('HTTP_', '').titleize.gsub(' ', '-') => v) }.as_json}"
    end

    def authenticate_user!(opts = {})
      catch(:warden) { super(opts) }

      raise UnauthorizedException unless current_user
    end

    def after_sign_in_path_for(_resource)
      raise SkipRedirectsException
    end

    def after_sign_out_path_for(_resource)
      raise SkipRedirectsException
    end

    def set_timezone(&)
      Time.use_zone(current_user&.timezone, &)
    end

    def set_locale(&)
      I18n.with_locale(current_user&.locale, &)
    end

    def unauthorized
      render json: {
        alert: flash.alert || I18n.t!('login.failure.unauthorized'),
        redirect: new_login_session_path,
        locale: I18n.locale,
        timezone: Time.zone.name
      }, status: :unauthorized
    end

    def not_found
      render json: {
        alert: flash.alert || I18n.t!('login.failure.not_found'),
        locale: I18n.locale,
        timezone: Time.zone.name
      }, status: :not_found
    end

    def unprocessable_entity
      render json: {
        alert: flash.alert || I18n.t!('login.failure.unprocessable_entity'),
        locale: I18n.locale,
        timezone: Time.zone.name
      }, status: :unprocessable_entity
    end

    def _wrapper_key
      'user'
    end

    def set_new_relic_controller
      ::NewRelic::Agent::Tracer.current_segment.instance_variable_set(:@controller, self)
    end
  end
end
