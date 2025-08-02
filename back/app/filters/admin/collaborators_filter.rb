module ADMIN
  class CollaboratorsFilter < ApplicationFilter
    MODEL = ::Collaborator

    search_attributes(
      boolean: %i[actived],
      string: %i[user_email subscription_name],
      key: %i[user_uuid subscription_id]
    )

    private

    def select
      %i[
        id
        actived
        user_id
        user_uuid
        user_email
        subscription_id
        subscription_name
        created_at
        updated_at
      ]
    end

    def sql
      MODEL.unscoped.select(
        *column_names,
        'users.uuid AS user_uuid',
        'users.email AS user_email',
        'users.searchable_email AS searchable_user_email',
        'subscriptions.name AS subscription_name',
        'subscriptions.searchable_name AS searchable_subscription_name'
      ).joins(:user, :subscription).to_sql
    end
  end
end
