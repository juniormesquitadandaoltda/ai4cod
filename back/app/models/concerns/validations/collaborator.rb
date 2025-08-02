module Validations
  module Collaborator
    extend ::ActiveSupport::Concern
    included do
      validates :user, presence: true, persistence: true, unchange: true, comparison: { other_than: :subscription_user },
                       uniqueness: { scope: :subscription_id }
      validates :subscription, presence: true, persistence: true, unchange: true

      validates :actived, presence: false

      validate :validate_user_profile

      private

      def validate_user_profile
        errors.add(:user, :invalid_profile) if user && !user.profile_standard?
      end
    end
  end
end
