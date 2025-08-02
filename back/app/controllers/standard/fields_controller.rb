module STANDARD
  class FieldsController < ApplicationController
    FILTER = FieldsFilter
    MODEL = ::Field

    before_action :set_model!, only: %i[show edit update]

    def index
      @filter = FILTER.new(filter_params)
      @filter.search
      respond_with @filter
    end

    def show; end

    def edit; end

    def update
      @model.custom_update model_params
      respond_with @model
    end

    private

    def set_model!
      @model = current_subscription.fields.find params[:id]
    end

    def filter_params
      @filter_params ||= params.permit(search_attributes(FILTER)).merge(
        current_user:, current_subscription:
      )
    end

    def model_params
      params.fetch(:model, {}).permit(:values, values: []).merge(
        subscription: { id: current_subscription.id }
      )
    end
  end
end
