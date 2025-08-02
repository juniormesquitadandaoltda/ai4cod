module ADMIN
  class CollaboratorsPolicy < ApplicationPolicy
    def index
      admin?
    end

    def show
      admin? && exists?
    end

    private

    def exists?
      ::Collaborator.exists?(id: params[:id])
    end
  end
end
