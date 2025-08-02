module ADMIN
  class FieldsPolicy < ApplicationPolicy
    def index
      admin?
    end

    def show
      admin? && exists?
    end

    private

    def exists?
      ::Field.exists?(id: params[:id])
    end
  end
end
