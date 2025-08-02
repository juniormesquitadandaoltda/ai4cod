module ADMIN
  class NotificationsFilter < ApplicationFilter
    MODEL = ::Notification

    search_attributes(
      string: %i[notificator_name],
      key: %i[notificator_id]
    )

    private

    def select
      %i[
        id
        notificator_id
        notificator_name
        created_at
        updated_at
      ]
    end

    def sql
      MODEL.unscoped.select(
        *column_names,
        'notificators.name AS notificator_name',
        'notificators.searchable_name AS searchable_notificator_name'
      ).joins(:notificator).to_sql
    end
  end
end
