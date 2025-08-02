module Validations
  module Archive
    extend ::ActiveSupport::Concern
    included do
      delegate :url, to: :blob, allow_nil: true

      validates :filename, presence: true

      def self.custom_create(attributes = {})
        archives = ::Subscription.find(
          attributes.dig(:subscription, :id)
        ).send(
          attributes.dig(:record, :type).underscore.pluralize
        ).find(
          attributes.dig(:record, :id)
        ).archives

        archives.attach(
          io: StringIO.new(Base64.decode64(attributes[:base64].to_s.split(',').last)),
          filename: attributes[:filename],
          metadata: {
            identified: true,
            analyzed: true
          }
        )

        archives.last.becomes(self)
      rescue => e
        instance = new(
          record_type: attributes.dig(:record, :type),
          record_id: attributes.dig(:record, :id)
        )
        instance.valid?
        instance
      end

      def destroy
        ::ApplicationRecord.no_touching { super }
      end

      def filename
        blob&.filename&.to_s
      end

      def filename=(value)
        blob.filename = value if blob
      end

      def byte_size
        blob&.byte_size
      end
    end
  end
end
