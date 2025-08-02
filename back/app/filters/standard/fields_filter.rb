module STANDARD
  class FieldsFilter < ApplicationFilter
    MODEL = ::Field

    search_attributes(
      enum: %i[resource name]
    )

    private

    def select
      %i[
        id
        name
        resource
        created_at
        updated_at
      ]
    end

    def sql
      MODEL.unscoped.where(subscription: current_subscription).to_sql
    end
  end
end
