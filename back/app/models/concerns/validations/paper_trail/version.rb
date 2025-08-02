module Validations
  module PaperTrail
    module Version
      extend ::ActiveSupport::Concern
      included do
        enum event: %i[create update destroy].reduce({}) { |h, v| h.merge!(v => v.to_s) }, _prefix: true

        before_validation :config_whodunnit!, on: :create
        before_validation :config_owner!, on: :create

        validates :event, presence: true, unchange: true
        validates :whodunnit, presence: true, persistence: true, unchange: true
        validates :owner, presence: true, persistence: true, unchange: true
        validates :object_changes, presence: true

        after_create_commit :after_create_self!

        private

        def config_whodunnit!
          return if !item || whodunnit&.profile_admin?

          self.whodunnit = if item.is_a?(User)
                             item
                           elsif item.respond_to?(:subscription)
                             item.subscription.user
                           else
                             item.user
                           end
        end

        def config_owner!
          return unless item

          self.owner = if whodunnit&.profile_admin?
                         whodunnit
                       elsif item.is_a?(User)
                         item
                       elsif item.respond_to?(:subscription)
                         item.subscription.user
                       else
                         item.user
                       end
        end

        def after_create_self!
          if ::Webhook.resources.keys.include?(item_type.underscore)
            ::STANDARD::AuditsJob.perform_later(
              audit: self,
              whodunnit: ::PaperTrail.request.whodunnit
            )
          end
        end
      end
    end
  end
end
