module STANDARD
  class WebhooksController < ApplicationController
    FILTER = WebhooksFilter
    MODEL = ::Webhook

    before_action :set_model!, only: %i[show edit update destroy]

    def index
      @filter = FILTER.new(filter_params)
      @filter.search
      respond_with @filter
    end

    def show; end

    def new; end

    def edit; end

    def create
      @model = MODEL.custom_create(model_params)
      respond_with @model
    end

    def update
      @model.custom_update model_params
      respond_with @model
    end

    def destroy
      @model.destroy
      respond_with @model
    end

    private

    def set_model!
      @model = current_subscription.webhooks.find params[:id]
    end

    def filter_params
      @filter_params ||= params.permit(search_attributes(FILTER)).merge(
        current_user:, current_subscription:
      )
    end

    def model_params
      params.fetch(:model, {}).permit(:actived, :url, :resource, :event).merge(
        subscription: { id: current_subscription.id }
      )
    end
  end
end
