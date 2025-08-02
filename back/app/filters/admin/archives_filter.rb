module ADMIN
  class ArchivesFilter < ApplicationFilter
    MODEL = ::Archive

    search_attributes(
      key: %i[record_id subscription_id],
      string: %i[filename subscription_name record_type]
    )

    def results
      super.each do |result|
        class << result
          def filename
            self[:filename]
          end
        end
      end
    end

    private

    def select
      %i[
        id
        filename
        record_id
        record_type
        subscription_id
        subscription_name
        created_at
        updated_at
      ]
    end

    def sql
      MODEL.unscoped.select(
        *column_names,
        'active_storage_blobs.filename AS filename',
        'active_storage_blobs.searchable_filename AS searchable_filename',
        'subscriptions.name AS subscription_name',
        'subscriptions.searchable_name AS searchable_subscription_name'
      ).joins(:blob, :subscription).to_sql
    end
  end
end
