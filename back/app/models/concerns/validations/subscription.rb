module Validations
  module Subscription
    extend ::ActiveSupport::Concern
    included do
      validates :name, presence: true, uniqueness: { scope: :user_id, case_sensitive: false }
      validates :user, presence: true, persistence: true, unchange: true
      validates :due_date, presence: true
      validates :current_records_count, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: :maximum_records_count }
      validates :maximum_records_count, presence: true, numericality: { greater_than_or_equal_to: 0 }
      validates :actived, presence: false
      validate :validate_user_profile

      after_create_commit :after_create_fields!

      def expired?
        due_date && due_date < Date.current
      end

      def self.counts
        (
          column_names.select { |n| n.end_with?('_count') }.sort - %w[maximum_records_count current_records_count]
        ).map(&:to_sym)
      end

      private

      def validate_user_profile
        errors.add(:user, :invalid_profile) if user && !user.profile_standard?
      end

      def after_create_fields!
        ::STANDARD::SubscriptionsJob.perform(
          subscription: self,
          whodunnit: ::PaperTrail.request.whodunnit
        )
      end
    end
  end
end
