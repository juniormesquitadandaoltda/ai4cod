module ADMIN
  class WebhooksPolicy < ApplicationPolicy
    def index
      admin?
    end

    def show
      admin? && exists?
    end

    private

    def exists?
      ::Webhook.exists?(id: params[:id])
    end
  end
end
