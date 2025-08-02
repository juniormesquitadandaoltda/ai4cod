module STANDARD
  class SessionsService < ApplicationService
    attr_accessor :user, :subscription

    delegate :id, to: :subscription, prefix: true, allow_nil: true

    validates :user, presence: true, persistence: true

    def call(attributes = {})
      valid? && run(attributes)
      errors.empty?
    end

    def subscriptions
      Subscription.left_joins(:collaborators).where(
        '(collaborators.actived AND collaborators.user_id = :user_id) OR (subscriptions.actived AND subscriptions.user_id = :user_id)', user_id: user.id
      )
    end

    private

    def run(attributes)
      if (id = attributes.dig(:subscription, :id)).present? && !valid_subscription?(id)
        errors.add(:subscription, :invalid)
      end

      @result = errors.empty?
    end

    def valid_subscription?(id)
      (@subscription = Subscription.where(actived: true).find_by(id:)).present? && (
        subscription.user_id == user.id ||
        user.collaborations.exists?(actived: true, subscription_id: subscription.id)
      )
    end
  end
end
