module ADMIN
  class TasksPolicy < ApplicationPolicy
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
      ::Task.exists?(id: params[:id])
    end
  end
end
