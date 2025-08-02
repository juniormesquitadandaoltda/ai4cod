module STANDARD
  class FieldsPolicy < ApplicationPolicy
    def index
      collaborator_readonly?
    end

    def show
      collaborator_readonly? && exists?
    end

    def edit
      collaborator? && exists?
    end

    def update
      collaborator? && exists?
    end

    private

    def exists?
      subscription.fields.exists?(id: params[:id])
    end
  end
end
