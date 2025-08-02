module ADMIN
  class NotificatorsFilter < ApplicationFilter
    MODEL = ::Notificator

    search_attributes(
      string: %i[name],
      boolean: %i[actived]
    )

    private

    def select
      %i[
        id
        name
        actived
        notifications_count
        created_at
        updated_at
      ]
    end

    def sql
      MODEL.unscoped.to_sql
    end
  end
end
