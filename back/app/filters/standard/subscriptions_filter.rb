module STANDARD
  class SubscriptionsFilter < ApplicationFilter
    MODEL = ::Subscription

    search_attributes(
      string: %i[name]
    )

    private

    def select
      %i[
        id
        name
      ]
    end

    def sql
      MODEL.unscoped.left_joins(:collaborators).where(
        '(collaborators.actived AND collaborators.user_id = :user_id) OR (subscriptions.actived AND subscriptions.user_id = :user_id)', user_id: current_user.id
      ).to_sql
    end
  end
end
