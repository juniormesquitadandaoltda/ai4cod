module ADMIN
  class WebhooksFilter < ApplicationFilter
    MODEL = ::Webhook

    search_attributes(
      string: %i[url subscription_name],
      enum: %i[resource event],
      boolean: %i[actived],
      key: %i[subscription_id]
    )

    private

    def select
      %i[
        id
        url
        resource
        event
        actived
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
