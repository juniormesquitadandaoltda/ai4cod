module ADMIN
  class NotificatorsPolicy < ApplicationPolicy
    def index
      admin?
    end

    def show
      admin? && exists?
    end

    def new
      admin?
    end

    def edit
      admin? && exists?
    end

    def create
      admin?
    end

    def update
      admin? && exists?
    end

    def destroy
      admin? && exists?
    end

    private

    def exists?
      ::Notificator.exists?(id: params[:id])
    end
  end
end
