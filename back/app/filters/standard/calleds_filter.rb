module STANDARD
  class CalledsFilter < ApplicationFilter
    MODEL = ::Called

    search_attributes(
      string: %i[subject]
    )

    private

    def select
      %i[
        id
        subject
        created_at
        updated_at
      ]
    end

    def sql
      MODEL.unscoped.where(subscription: current_subscription).to_sql
    end
  end
end
