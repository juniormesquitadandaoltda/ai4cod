module ADMIN
  class NotificationsPolicy < ApplicationPolicy
    def index
      admin?
    end

    def show
      admin? && exists?
    end

    private

    def exists?
      ::Notification.exists?(id: params[:id])
    end
  end
end
