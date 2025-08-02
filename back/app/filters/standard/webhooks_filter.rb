module STANDARD
  class WebhooksFilter < ApplicationFilter
    MODEL = ::Webhook

    search_attributes(
      string: %i[url],
      enum: %i[resource event],
      boolean: %i[actived]
    )

    private

    def select
      %i[
        id
        url
        resource
        event
        actived
        created_at
        updated_at
      ]
    end

    def sql
      MODEL.unscoped.where(subscription: current_subscription).to_sql
    end
  end
end
