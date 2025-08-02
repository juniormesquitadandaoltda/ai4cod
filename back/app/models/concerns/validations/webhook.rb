module Validations
  module Webhook
    extend ::ActiveSupport::Concern
    included do
      enum resource: %i[collaborator].reduce({}) { |h, p| h.merge!(p => p.to_s) }, _prefix: true
      enum event: %i[create update destroy].reduce({}) { |h, p| h.merge!(p => p.to_s) }, _prefix: true

      validates :resource, presence: true, enum: true
      validates :event, presence: true, enum: true
      validates :url, presence: true, uniqueness: { scope: %i[event subscription_id], case_sensitive: false }
      validates :actived, presence: false
      validates :subscription, presence: true, persistence: true, unchange: true
    end
  end
end
