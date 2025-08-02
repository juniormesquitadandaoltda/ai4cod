module Validations
  module Proprietor
    extend ::ActiveSupport::Concern
    included do
      validates :name, presence: true
      validates :email, presence: true, uniqueness: { scope: :subscription_id, case_sensitive: false }
      validates :subscription, presence: true, persistence: true, unchange: true
    end
  end
end
