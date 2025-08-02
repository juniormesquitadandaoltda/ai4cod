require 'base_responder'

module ADMIN
  class ApplicationController < ::ActionController::Base
    include ::Pundit::Authorization

    self.responder = ::BaseResponder

    respond_to :json

    rescue_from ::Login::UnauthorizedException, with: :unauthorized
    rescue_from ::ActionController::UnknownFormat, with: :not_found
    rescue_from ::ActionController::InvalidAuthenticityToken, with: :unprocessable_entity
    rescue_from ::Pundit::NotAuthorizedError, with: :not_found
    rescue_from ::ActiveRecord::RecordNotFound, with: :not_found

    before_action :log_headers!
    before_action :verify_requested_format!
    before_action :authenticate_user!
    before_action :authorize_user!
    before_action :set_paper_trail_whodunnit

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

      raise ::Login::UnauthorizedException unless current_user
    end

    def pundit_user
      {
        user: current_user,
        params: params.as_json(except: %i[controller action format]).deep_symbolize_keys
      }
    end

    def authorize_user!
      authorize controller_path.to_sym, action_name.to_sym
    end

    def user_for_paper_trail
      current_user
    end

    def set_timezone(&)
      Time.use_zone(current_user.timezone, &)
    end

    def set_locale(&)
      I18n.with_locale(current_user.locale, &)
    end

    def search_attributes(klass)
      @search_attributes ||= klass.search_attributes.map do |type, columns|
        if %i[string text].include?(type)
          columns.map { |k| %I[#{k} #{k}_in] }.flatten
        elsif %i[enum boolean key].include?(type)
          columns
        else
          columns.map { |k| %I[#{k} #{k}_gt #{k}_gte #{k}_lt #{k}_lte] }.flatten
        end
      end.flatten + %i[sort order page limit]
    end

    def flash_interpolation_options
      { destroy_alert: @model.errors[:base].first } if @model
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
      'model'
    end

    def set_new_relic_controller
      ::NewRelic::Agent::Tracer.current_segment.instance_variable_set(:@controller, self)
    end
  end
end
