module STANDARD
  class ProprietorsPolicy < ApplicationPolicy
    def index
      collaborator_readonly?
    end

    def index_archives
      index
    end

    def show
      collaborator_readonly? && exists?
    end

    def new
      collaborator?
    end

    def new_archives
      new
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
      subscription.proprietors.exists?(id: params[:id])
    end
  end
end
