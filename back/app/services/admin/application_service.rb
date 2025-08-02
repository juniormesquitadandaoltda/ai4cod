module ADMIN
  class ApplicationService
    include ActiveModel::Model

    def call
      valid? && run
      errors.empty?
    end
  end
end
