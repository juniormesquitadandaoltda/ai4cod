module Validations
  module Task
    extend ::ActiveSupport::Concern
    included do
      validates :name, presence: true
      validates :stage, presence: true, field_enum: true

      validates :next_stage, presence: false, field_enum: true
      validates :scheduling_at, presence: false, timeliness: { type: :datetime, allow_nil: true }

      validates :vehicle, presence: true, persistence: true

      validates :notes, presence: false, length: { maximum: 1024 }

      validates :shared, presence: false

      validates :facilitator, presence: false, persistence: true
      validates :proprietor, presence: false, persistence: true
      validates :subscription, presence: true, persistence: true, unchange: true
    end
  end
end
