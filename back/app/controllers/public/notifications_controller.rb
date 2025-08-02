module PUBLIC
  class NotificationsController < ApplicationController
    MODEL = ::Notification

    before_action :set_notificator!

    def create
      @model = MODEL.custom_create(model_params)
      respond_with @model
    end

    private

    def set_notificator!
      @notificator = ::Notificator.find_by!(token: params[:notificator_token])
    end

    def model_params
      {
        url: request.url,
        headers: request.headers.to_h.select { |k, _v| k.start_with?('HTTP_') || k.start_with?('CONTENT_') }.reduce({}) { |h, (k, v)| h.merge(k.gsub('HTTP_', '').titleize.gsub(' ', '-') => v) },
        body: request.request_parameters,
        notificator: @notificator
      }
    end
  end
end
