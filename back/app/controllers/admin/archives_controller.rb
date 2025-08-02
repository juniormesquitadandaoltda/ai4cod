module ADMIN
  class ArchivesController < ApplicationController
    FILTER = ArchivesFilter
    MODEL = ::Archive

    before_action :set_model!, only: :show

    def index
      @filter = FILTER.new(filter_params)
      @filter.search
      respond_with @filter
    end

    def show; end

    private

    def set_model!
      @model = MODEL.unscoped.find params[:id]
    end

    def filter_params
      params.permit(search_attributes(FILTER)).merge(
        current_user:
      )
    end
  end
end
