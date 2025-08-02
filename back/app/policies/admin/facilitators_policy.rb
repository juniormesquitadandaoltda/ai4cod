module ADMIN
  class FacilitatorsPolicy < ApplicationPolicy
    def index
      admin?
    end

    def show
      admin? && exists?
    end

    def index_archives
      index
    end

    private

    def exists?
      ::Facilitator.exists?(id: params[:id])
    end
  end
end
