module ADMIN
  class ArchivesPolicy < ApplicationPolicy
    def index
      admin?
    end

    def show
      admin? && exists?
    end

    private

    def exists?
      ::Archive.exists?(id: params[:id])
    end
  end
end
