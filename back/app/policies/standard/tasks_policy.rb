module STANDARD
  class TasksPolicy < ApplicationPolicy
    def index
      client_readonly?
    end

    def index_archives
      collaborator_readonly?
    end

    def show
      client_readonly? && exists?
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
      client.tasks.exists?(id: params[:id])
    end
  end
end
