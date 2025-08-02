module STANDARD
  class SubscriptionsController < ApplicationController
    MODEL = ::Subscription

    before_action :set_model!

    def show; end

    private

    def set_model!
      @model = current_subscription
    end
  end
end
