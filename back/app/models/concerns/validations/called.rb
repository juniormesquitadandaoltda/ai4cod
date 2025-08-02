module Validations
  module Called
    extend ::ActiveSupport::Concern
    included do
      validates :subject, presence: true, uniqueness: { scope: :subscription_id, case_sensitive: false }
      validates :message, presence: true, change: :answer_blank?
      validates :subscription, presence: true, persistence: true, unchange: true

      private

      def answer_blank?
        answer.blank?
      end
    end
  end
end
