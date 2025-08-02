module ADMIN
  class CalledsPolicy < ApplicationPolicy
    def index
      admin?
    end

    def show
      admin? && exists?
    end

    def edit
      admin? && exists?
    end

    def update
      admin? && exists?
    end

    private

    def exists?
      ::Called.exists?(id: params[:id])
    end
  end
end
