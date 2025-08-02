module STANDARD
  class CollaboratorsPolicy < ApplicationPolicy
    def index
      collaborator_readonly?
    end

    def show
      collaborator_readonly? && exists?
    end

    def new
      subscriber?
    end

    def edit
      subscriber? && exists?
    end

    def create
      subscriber?
    end

    def update
      subscriber? && exists?
    end

    def destroy
      subscriber? && exists?
    end

    private

    def exists?
      subscription.collaborators.exists?(id: params[:id])
    end
  end
end
