module ADMIN
  class UsersController < ApplicationController
    FILTER = UsersFilter
    MODEL = ::User

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

    def personificate
      session[:personification_id] = MODEL.unscoped.profile_standard.find(params[:id]).id
    end

    private

    def set_model!
      @model = MODEL.unscoped.find params[:id]
    end

    def filter_params
      params.permit(search_attributes(FILTER)).merge(
        current_user:
      )
    end

    def model_params
      params.fetch(:model, {}).permit(:profile)
    end
  end
end
