module ADMIN
  class SubscriptionsFilter < ApplicationFilter
    MODEL = ::Subscription

    search_attributes(
      string: %i[name user_email],
      boolean: %i[actived],
      key: %i[user_uuid],
      date: %i[due_date]
    )

    private

    def select
      %i[
        id
        name
        actived
        due_date
        user_id
        user_uuid
        user_email
        created_at
        updated_at
      ]
    end

    def sql
      MODEL.unscoped.select(
        *column_names,
        'users.uuid AS user_uuid',
        'users.email AS user_email',
        'users.searchable_email AS searchable_user_email'
      ).joins(:user).to_sql
    end
  end
end
