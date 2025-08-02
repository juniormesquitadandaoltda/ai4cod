module STANDARD
  class AuditsFilter < ApplicationFilter
    MODEL = ::Audit

    search_attributes(
      key: %i[item_id whodunnit_uuid item_type],
      string: %i[whodunnit_email],
      enum: %i[event]
    )

    private

    def select
      %i[
        id
        event
        item_id
        item_type
        whodunnit_id
        whodunnit_uuid
        whodunnit_email
        created_at
        updated_at
      ]
    end

    def sql
      MODEL.unscoped.select(
        *column_names,
        'whodunnits_audits.uuid AS whodunnit_uuid',
        'whodunnits_audits.email AS whodunnit_email',
        'whodunnits_audits.searchable_email AS searchable_whodunnit_email'
      ).joins(
        :owner, :whodunnit
      ).where(owner: current_subscription.user).to_sql
    end
  end
end
