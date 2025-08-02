module STANDARD
  class VehiclesFilter < ApplicationFilter
    MODEL = ::Vehicle

    search_attributes(
      string: %i[chassis year plate renavam licensing],
      bigint: %i[seats]
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
        created_at
        updated_at
      ]
    end

    def sql
      MODEL.unscoped.where(subscription: current_subscription).to_sql
    end
  end
end
