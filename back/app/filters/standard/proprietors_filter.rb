module STANDARD
  class ProprietorsFilter < ApplicationFilter
    MODEL = ::Proprietor

    search_attributes(
      string: %i[name email]
    )

    private

    def select
      %i[
        id
        name
        email
        created_at
        updated_at
      ]
    end

    def sql
      MODEL.unscoped.where(subscription: current_subscription).to_sql
    end
  end
end
