module STANDARD
  class ArchivesFilter < ApplicationFilter
    MODEL = ::Archive

    search_attributes(
      key: %i[record_id],
      string: %i[filename record_type]
    )

    def results
      super.each do |result|
        class << result
          def filename
            self[:filename]
          end

          def byte_size
            self[:byte_size]
          end
        end
      end
    end

    def sortables
      super + %w[byte_size]
    end

    private

    def select
      %i[
        id
        filename
        byte_size
        record_id
        record_type
        created_at
        updated_at
      ]
    end

    def sql
      MODEL.unscoped.select(
        *column_names,
        'active_storage_blobs.filename AS filename',
        'active_storage_blobs.searchable_filename AS searchable_filename',
        'active_storage_blobs.byte_size AS byte_size'
      ).joins(:blob, :subscription).where(
        subscription: current_subscription
      ).to_sql
    end
  end
end
