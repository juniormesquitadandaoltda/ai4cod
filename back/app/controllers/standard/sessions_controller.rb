module STANDARD
  class SessionsController < ApplicationController
    MODEL = ::User

    before_action :set_model!

    def show; end

    private

    def set_model!
      @model = current_user
    end
  end
end
