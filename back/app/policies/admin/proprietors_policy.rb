module ADMIN
  class ProprietorsPolicy < ApplicationPolicy
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
      ::Proprietor.exists?(id: params[:id])
    end
  end
end
