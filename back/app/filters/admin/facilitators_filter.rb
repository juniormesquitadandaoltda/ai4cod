module ADMIN
  class FacilitatorsFilter < ApplicationFilter
    MODEL = ::Facilitator

    search_attributes(
      string: %i[name email subscription_name],
      key: %i[subscription_id]
    )

    private

    def select
      %i[
        id
        name
        email
        subscription_id
        subscription_name
        created_at
        updated_at
      ]
    end

    def sql
      MODEL.unscoped.select(
        *column_names,
        'subscriptions.name AS subscription_name',
        'subscriptions.searchable_name AS searchable_subscription_name'
      ).joins(:subscription).to_sql
    end
  end
end
