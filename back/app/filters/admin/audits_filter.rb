module ADMIN
  class AuditsFilter < ApplicationFilter
    MODEL = ::Audit

    search_attributes(
      key: %i[item_id whodunnit_uuid owner_uuid item_type],
      string: %i[whodunnit_email owner_email],
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
        owner_id
        owner_uuid
        owner_email
        created_at
        updated_at
      ]
    end

    def sql
      MODEL.unscoped.select(
        *column_names,
        'whodunnits.uuid AS whodunnit_uuid',
        'whodunnits.email AS whodunnit_email',
        'whodunnits.searchable_email AS searchable_whodunnit_email',
        'owners.uuid AS owner_uuid',
        'owners.email AS owner_email',
        'owners.searchable_email AS searchable_owner_email'
      ).joins(
        'INNER JOIN users AS whodunnits ON whodunnits.id = audits.whodunnit_id',
        'INNER JOIN users AS owners ON owners.id = audits.owner_id'
      ).to_sql
    end
  end
end
