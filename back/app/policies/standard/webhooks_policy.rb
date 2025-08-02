module STANDARD
  class WebhooksPolicy < ApplicationPolicy
    def index
      collaborator_readonly?
    end

    def show
      collaborator_readonly? && exists?
    end

    def new
      collaborator?
    end

    def edit
      collaborator? && exists?
    end

    def create
      collaborator?
    end

    def update
      collaborator? && exists?
    end

    def destroy
      collaborator? && exists?
    end

    private

    def exists?
      subscription.webhooks.exists?(id: params[:id])
    end
  end
end
