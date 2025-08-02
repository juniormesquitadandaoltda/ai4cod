Rails.application.config.to_prepare do
  require 'paper_trail/version'
  require 'active_storage/attachment'

  module ActiveStorage
    class Attachment
      include ::Validations::ApplicationRecord

      belongs_to :subscription, counter_cache: :archives_count

      before_validation :config_subscription!, on: :create

      validates :subscription, presence: true, persistence: true, unchange: true
      validates :record, presence: true, persistence: true, unchange: true

      private

      def config_subscription!
        if record.respond_to?(:subscription)
          self.subscription = record.subscription
          before_validation_subscription_current_records_count!
          before_validation_subscription_due_date!
        end
      end
    end
  end
end
