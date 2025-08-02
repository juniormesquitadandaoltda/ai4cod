module STANDARD
  class UsersFilter < ApplicationFilter
    MODEL = ::User

    search_attributes(
      key: %i[uuid]
    )

    def sortables
      super + %w[email]
    end

    private

    def select
      %i[
        uuid
        email
      ]
    end

    def sql
      MODEL.unscoped.status_created.profile_standard.where.not(id: current_subscription.user_id).where(uuid:).to_sql
    end
  end
end
