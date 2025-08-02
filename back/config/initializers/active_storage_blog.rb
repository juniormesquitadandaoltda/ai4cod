Rails.application.config.to_prepare do
  require 'paper_trail/version'
  require 'active_storage/blob'

  module ActiveStorage
    class Blob
      include ::Validations::ApplicationRecord

      def self.generate_unique_secure_token(length: MINIMUM_TOKEN_LENGTH)
        [Rails.env, 'storage', SecureRandom.base58(length)].join('/')
      end

      def identified?
        true
      end

      def analyzed?
        true
      end

      private

      def after_save_configure_searchable!
        return if @last_filename == self[:filename]

        self.class.unscoped.where(id:).update_all(
          "searchable_filename = UNACCENT(LOWER(TRIM(filename))) || ''"
        )

        @last_filename = self[:filename]
      end
    end
  end
end
