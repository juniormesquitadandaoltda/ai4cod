module STANDARD
  class SubscriptionsPolicy < ApplicationPolicy
    def show
      subscriber_readonly?
    end
  end
end
