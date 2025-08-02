module STANDARD
  class UsersController < ApplicationController
    FILTER = UsersFilter
    MODEL = ::User

    def index
      @filter = FILTER.new(filter_params)
      @filter.search
      respond_with @filter
    end

    private

    def filter_params
      @filter_params ||= params.permit(search_attributes(FILTER)).merge(
        current_user:, current_subscription:
      )
    end
  end
end
