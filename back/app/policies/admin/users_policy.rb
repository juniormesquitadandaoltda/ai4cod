module ADMIN
  class UsersPolicy < ApplicationPolicy
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

    def personificate
      admin? && ::User.status_created.profile_standard.exists?(id: params[:id])
    end

    private

    def exists?
      ::User.status_created.exists?(id: params[:id])
    end
  end
end
