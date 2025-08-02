module STANDARD
  class AuditsController < ApplicationController
    FILTER = AuditsFilter
    MODEL = ::Audit

    before_action :set_model!, only: :show

    def index
      @filter = FILTER.new(filter_params)
      @filter.search
      respond_with @filter
    end

    def show; end

    private

    def set_model!
      @model = current_subscription.user.audits.find params[:id]
    end

    def filter_params
      params.permit(search_attributes(FILTER)).merge(
        current_user:, current_subscription:
      )
    end
  end
end
