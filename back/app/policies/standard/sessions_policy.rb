module STANDARD
  class SessionsPolicy < ApplicationPolicy
    def show
      standard?
    end
  end
end
