module ADMIN
  class SwaggerPolicy < ApplicationPolicy
    def show
      admin? && exists?
    end

    private

    def exists?
      {
        'v1' => {
          admin: true,
          login: true,
          standard: true
        }
      }.dig(params[:version], params[:file].to_sym)
    end
  end
end
