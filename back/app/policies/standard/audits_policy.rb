module STANDARD
  class AuditsPolicy < ApplicationPolicy
    def index
      subscriber_readonly?
    end

    def show
      subscriber_readonly? && exists?
    end

    private

    def exists?
      subscription.user.audits.exists?(id: params[:id])
    end
  end
end
