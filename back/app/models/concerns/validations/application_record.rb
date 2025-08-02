module Validations
  module ApplicationRecord
    extend ::ActiveSupport::Concern

    included do
      before_validation :before_validation_subscription_current_records_count!, on: :create
      before_validation :before_validation_subscription_due_date!

      after_create_commit :after_create_subscription_current_records_count!

      after_save_commit :after_save_configure_searchable!

      after_destroy_commit :after_destroy_subscription_current_records_count!

      def self.custom_create(attributes = {})
        safe_attributes = attributes.as_json.deep_symbolize_keys

        reflect_on_all_associations(:belongs_to).each do |belongs_to_reflection|
          model_name = belongs_to_reflection.name.to_sym
          next unless safe_attributes.key?(model_name)

          safe_attributes[model_name] = if safe_attributes[model_name].blank?
                                          nil
                                        elsif model_name != :user && (id = safe_attributes.dig(model_name, :id))
                                          belongs_to_reflection.class_name.safe_constantize.find_or_initialize_by(id:)
                                        elsif model_name == :user && (uuid = safe_attributes.dig(model_name, :uuid))
                                          belongs_to_reflection.class_name.safe_constantize.find_or_initialize_by(uuid:)
                                        elsif model_name == :notificator && (token = safe_attributes.dig(model_name, :token))
                                          belongs_to_reflection.class_name.safe_constantize.find_or_initialize_by(token:)
                                        else
                                          belongs_to_reflection.class_name.safe_constantize.new
                                        end
        end

        create safe_attributes
      end

      def custom_update(attributes = {})
        safe_attributes = attributes.as_json.deep_symbolize_keys

        if attributes[:current_user]
          safe_attributes.merge!(
            current_user: attributes[:current_user]
          )
        end

        self.class.reflect_on_all_associations(:belongs_to).each do |belongs_to_reflection|
          model_name = belongs_to_reflection.name.to_sym
          next unless safe_attributes.key?(model_name)

          safe_attributes[model_name] = if safe_attributes[model_name].blank?
                                          nil
                                        elsif model_name != :user && (id = safe_attributes.dig(model_name, :id))
                                          belongs_to_reflection.class_name.safe_constantize.find_or_initialize_by(id:)
                                        elsif model_name == :user && (uuid = safe_attributes.dig(model_name, :uuid))
                                          belongs_to_reflection.class_name.safe_constantize.find_or_initialize_by(uuid:)
                                        elsif model_name == :notificator && (token = safe_attributes.dig(model_name, :token))
                                          belongs_to_reflection.class_name.safe_constantize.find_or_initialize_by(token:)
                                        else
                                          belongs_to_reflection.class_name.safe_constantize.new
                                        end
        end

        update safe_attributes
      end

      private

      def respond_to_missing?(method_name, include_private = false)
        (
          method_name.to_s.start_with?('field_') &&
          ::Field.resources.keys.include?(self.class.name.underscore) &&
          ::Field.names.keys.include?(method_name.to_s.sub('field_', '').sub('next_', '').singularize)
        ) || super(method_name, include_private)
      end

      def method_missing(method_name, *args, &block)
        if method_name.to_s.start_with?('field_') && respond_to_missing?(method_name)
          attribute = method_name.to_s.sub('field_', '').sub('next_', '').to_sym
          field_(attribute)
        else
          super(method_name, *args, &block)
        end
      end

      def field_(attribute)
        pluralized = attribute.to_s.pluralize.to_sym
        singularized = attribute.to_s.singularize.to_sym

        return @field_.dig(pluralized) if @field_&.dig(pluralized)

        @field_ ||= {}

        @field_[pluralized] = subscription && subscription.fields.find_by(
          resource: self.class.name.underscore,
          name: singularized
        )&.values

        @field_.dig(pluralized) || []
      end

      def before_validation_subscription_current_records_count!
        if respond_to?(:subscription) && subscription && subscription.current_records_count >= subscription.maximum_records_count
          errors.add(
            :subscription,
            :subscription_current_records_count,
            value: subscription.current_records_count
          )
        end
      end

      def before_validation_subscription_due_date!
        if respond_to?(:subscription) && subscription&.expired?
          errors.add(
            :subscription,
            :subscription_due_date,
            value: I18n.l(subscription.due_date)
          )
        end
      end

      def after_save_configure_searchable!
        searchable_attribute_changeds = searchable_attributes.select { |attr| send(:"#{attr}_changed?") || send(:"saved_change_to_#{attr}?") }

        if searchable_attribute_changeds.any?
          self.class.unscoped.where(id:).update_all(
            searchable_attribute_changeds.map { |a| "searchable_#{a} = UNACCENT(LOWER(TRIM(#{a}))) || ''" }.join(', ')
          )
        end
      end

      def searchable_attributes
        @searchable_attributes ||= self.class.columns.select do |c|
                                     c.name.starts_with?('searchable_')
                                   end.map { |c| c.name.gsub('searchable_', '').to_sym }
      end

      def after_create_subscription_current_records_count!
        subscription.increment!(:current_records_count) if respond_to?(:subscription)
      end

      def after_destroy_subscription_current_records_count!
        subscription.decrement!(:current_records_count) if respond_to?(:subscription)
      end
    end
  end
end
