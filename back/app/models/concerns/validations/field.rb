module Validations
  module Field
    extend ::ActiveSupport::Concern
    included do
      enum resource: %i[task vehicle].reduce({}) { |h, p| h.merge!(p => p.to_s) }, _prefix: true
      enum name: %i[stage brand model color fuel category kind].reduce({}) { |h, p| h.merge!(p => p.to_s) }, _prefix: true

      before_validation :set_values!

      validates :resource, presence: true, enum: true, unchange: true
      validates :name, presence: true, enum: true, uniqueness: { scope: %i[resource subscription_id] }, unchange: true
      validates :values, presence: true
      validates :subscription, presence: true, persistence: true, unchange: true

      validate :validate_value_taken

      before_destroy :before_destroy_dependents!

      private

      def set_values!
        self.values = values.presence.to_a.map { |v| v.strip.presence }.compact.uniq
      end

      def validate_value_taken
        (values_was - values).each do |value|
          if resource.classify.safe_constantize&.exists?(name => value)
            errors.add(:values, :taken_value, value:)
            break
          end
        end
      end

      def before_destroy_dependents!
        values.each do |value|
          next unless resource.classify.safe_constantize&.exists?(name => value)

          errors.add(
            :base,
            :"restrict_dependent_destroy.has_many",
            record: self.class.human_attribute_name(resource.pluralize).downcase
          )
          throw :abort
        end
      end
    end
  end
end
