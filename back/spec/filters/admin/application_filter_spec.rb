require 'rails_helper'

module ADMIN
  RSpec.describe ApplicationFilter, type: :filter do
    let(:current_user) { create(:user) }

    let(:described_class) { Filter }
    let(:subject) { Filter.new }

    it '.search_attributes' do
      expect(subject).to admin_search_attributes(
        key: %i[key],
        string: %i[string],
        text: %i[text],
        enum: %i[status],
        boolean: %i[boolean],
        bigint: %i[bigint],
        decimal: %i[decimal],
        date: %i[date],
        time: %i[time],
        datetime: %i[datetime],
        timestamp: %i[timestamp]
      )
    end

    class Filter < ApplicationFilter
      MODEL = ::User

      search_attributes(
        key: %i[key],
        string: %i[string],
        text: %i[text],
        enum: %i[status],
        boolean: %i[boolean],
        bigint: %i[bigint],
        decimal: %i[decimal],
        date: %i[date],
        time: %i[time],
        datetime: %i[datetime],
        timestamp: %i[timestamp]
      )

      private

      def select
        %i[
          key
          string
          text
          status
          boolean
          bigint
          decimal
          date
          time
          datetime
          timestamp
        ]
      end

      def sql
        MODEL.unscoped.select(
          'NULL AS id',
          'NULL AS key',
          'NULL AS string',
          'NULL AS searchable_string',
          'NULL AS text',
          'NULL AS searchable_text',
          'NULL AS status',
          'NULL AS boolean',
          '0 AS bigint',
          '0.0 AS decimal',
          'NOW() AS date',
          'NOW() AS time',
          'NOW() AS datetime',
          'NOW() AS timestamp',
          'NOW() AS created_at',
          'NOW() AS updated_at'
        ).to_sql
      end
    end
  end
end
