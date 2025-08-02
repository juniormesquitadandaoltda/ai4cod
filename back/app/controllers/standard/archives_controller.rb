module STANDARD
  class ArchivesController < ApplicationController
    FILTER = ArchivesFilter
    MODEL = ::Archive

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
      @model = MODEL.custom_create(create_params)
      respond_with @model
    end

    def update
      @model.custom_update update_params
      respond_with @model
    end

    def destroy
      @model.destroy
      respond_with @model
    end

    private

    def set_model!
      @model = current_subscription.archives.find params[:id]
    end

    def filter_params
      @filter_params ||= params.permit(search_attributes(FILTER)).merge(
        current_user:, current_subscription:
      )
    end

    def create_params
      params.fetch(:model, {}).permit({ record: %i[id type] }, :filename, :base64).merge(
        subscription: { id: current_subscription.id }
      )
    end

    def update_params
      params.fetch(:model, {}).permit(:filename)
    end
  end
end
