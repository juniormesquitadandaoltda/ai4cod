module ADMIN
  class VehiclesPolicy < ApplicationPolicy
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
      ::Vehicle.exists?(id: params[:id])
    end
  end
end
