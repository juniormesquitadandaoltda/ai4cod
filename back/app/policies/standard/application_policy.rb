module STANDARD
  class ApplicationPolicy
    attr_reader :user, :subscription, :client, :params

    def initialize(pundit_user, _ = nil)
      @user = pundit_user[:user]
      @subscription = pundit_user[:subscription]
      @client = pundit_user[:client]
      @params = pundit_user[:params]
    end

    private

    def standard?
      user.profile_standard?
    end

    def subscriber?
      @subscriber ||= standard? && subscription&.actived? && !subscription.expired? && subscription.user_id == user.id
    end

    def subscriber_readonly?
      @subscriber_readonly ||= subscriber? || (
        standard? && subscription&.actived? && subscription&.expired? && subscription.user_id == user.id
      )
    end

    def collaborator?
      @collaborator ||= subscriber? || (
        standard? && subscription&.actived? && !subscription.expired? && user.collaborations.exists?(actived: true, subscription_id: subscription.id)
      )
    end

    def collaborator_readonly?
      @collaborator_readonly ||= collaborator? || (
        standard? && subscription&.actived? && subscription&.expired? && user.collaborations.exists?(actived: true, subscription_id: subscription.id)
      )
    end

    def client_readonly?
      @client_readonly ||= collaborator_readonly? || client.tasks.any?
    end
  end
end
