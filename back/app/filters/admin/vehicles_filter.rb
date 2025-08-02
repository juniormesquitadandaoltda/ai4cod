module ADMIN
  class VehiclesFilter < ApplicationFilter
    MODEL = ::Vehicle

    search_attributes(
      string: %i[chassis year plate renavam licensing subscription_name],
      bigint: %i[seats],
      key: %i[subscription_id]
    )

    private

    def select
      %i[
        id
        chassis
        year
        seats
        plate
        renavam
        licensing
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
