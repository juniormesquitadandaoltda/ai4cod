module Validations
  module Vehicle
    extend ::ActiveSupport::Concern
    included do
      validates :chassis, presence: true, uniqueness: { scope: :subscription_id, case_sensitive: false }
      validates :year, presence: true, format: { with: %r{\A\d{4}/\d{4}\z} }

      validates :brand, presence: true, field_enum: true
      validates :model, presence: true, field_enum: true
      validates :color, presence: true, field_enum: true
      validates :fuel, presence: true, field_enum: true
      validates :category, presence: true, field_enum: true
      validates :kind, presence: true, field_enum: true

      validates :licensing, presence: false, format: { with: %r{\A\d{4}/\d{4}\z} }

      validates :seats, presence: true, numericality: { only_integer: true, greater_than: 0 }

      validates :plate, presence: false
      validates :renavam, presence: false

      validates :notes, presence: false, length: { maximum: 1024 }

      validates :subscription, presence: true, persistence: true, unchange: true
    end
  end
end
