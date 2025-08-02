module ADMIN
  class UsersFilter < ApplicationFilter
    MODEL = ::User

    search_attributes(
      key: %i[uuid],
      string: %i[email],
      enum: %i[status profile]
    )

    private

    def select
      %i[
        id
        uuid
        email
        status
        profile
        created_at
        updated_at
      ]
    end

    def sql
      MODEL.unscoped.to_sql
    end
  end
end
