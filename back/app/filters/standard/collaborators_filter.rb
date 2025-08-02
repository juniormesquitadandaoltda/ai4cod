module STANDARD
  class CollaboratorsFilter < ApplicationFilter
    MODEL = ::Collaborator

    search_attributes(
      boolean: %i[actived],
      string: %i[user_email],
      key: %i[user_uuid]
    )

    private

    def select
      %i[
        id
        actived
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
      ).joins(:user).where(subscription: current_subscription).to_sql
    end
  end
end
