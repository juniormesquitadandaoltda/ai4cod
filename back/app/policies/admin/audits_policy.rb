module ADMIN
  class AuditsPolicy < ApplicationPolicy
    def index
      admin?
    end

    def show
      admin? && exists?
    end

    private

    def exists?
      ::Audit.exists?(id: params[:id])
    end
  end
end
