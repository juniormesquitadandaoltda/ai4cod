module ADMIN
  class SessionsPolicy < ApplicationPolicy
    def show
      admin?
    end
  end
end
