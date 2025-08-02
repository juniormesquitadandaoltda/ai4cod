module STANDARD
  class UsersPolicy < ApplicationPolicy
    def index
      subscriber_readonly?
    end
  end
end
