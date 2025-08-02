module Validations
  module User
    extend ::ActiveSupport::Concern
    included do
      enum timezone: %i[UTC Brasilia].reduce({}) { |h, v| h.merge!(v => v.to_s) }, _prefix: true
      enum locale: %i[en pt-BR].reduce({}) { |h, v| h.merge!(v => v.to_s) }, _prefix: true
      enum status: %i[created destroyed].reduce({}) { |h, v| h.merge!(v => v.to_s) }, _prefix: true
      enum profile: %i[standard admin].reduce({}) { |h, v| h.merge!(v => v.to_s) }, _prefix: true

      before_validation :config_name!, on: :create
      before_validation :config_timezone!, on: :create
      before_validation :config_locale!, on: :create
      before_validation :config_status!, on: :create
      before_validation :config_profile!, on: :create
      before_validation :config_password!, on: :create
      before_validation :config_access_sent_at!, on: :create

      validates :name, presence: true
      validates :timezone, presence: true, enum: true
      validates :locale, presence: true, enum: true
      validates :status, presence: true, enum: true
      validates :profile, presence: true, enum: true
      validates :email, presence: true, uniqueness: { case_sensitive: false }
      validates :destroyed_at, unchange: true
      validates :password_confirmation, presence: true, if: :password
      validates :policy_terms, presence: true

      alias_attribute :access_token, :password

      def valid_password?(token)
        "#{email}:#{sign_in_count}" == ActiveSupport::MessageEncryptor.new(
          Rails.application.secret_key_base[0...32]
        ).decrypt_and_verify(
          token.reverse.gsub('Ç', '==').gsub('ç', '=').gsub('Á', '--').gsub('á', '-').gsub('é', '/').gsub('É', '+').gsub('í', '_')
        ).split(':')[1..].join(':')
      rescue
        false
      end

      def generate_temp_password
        ActiveSupport::MessageEncryptor.new(
          Rails.application.secret_key_base[0...32]
        ).encrypt_and_sign(
          "#{SecureRandom.base58(200)}:#{email}:#{sign_in_count}", expires_in: 3.minutes
        ).reverse.gsub('==', 'Ç').gsub('=', 'ç').gsub('--', 'Á').gsub('-', 'á').gsub('/', 'é').gsub('+', 'É').gsub('_', 'í')
      end

      def send_reset_password_instructions
        send_reset_password_instructions_notification(nil)
      end

      def destroy
        now = Time.current
        update(destroyed_at: now, status: :destroyed) && update_columns(email: "#{email}.#{now.to_i}")
      end

      private

      def config_name!
        self.name = email&.split('@')&.first&.titlecase.presence
      end

      def config_timezone!
        self.timezone = :Brasilia
      end

      def config_locale!
        self.locale = :'pt-BR'
      end

      def config_status!
        self.status = :created
      end

      def config_profile!
        self.profile = :standard
      end

      def config_password!
        self.password = self.password_confirmation = Devise.friendly_token(32)
      end

      def config_access_sent_at!
        self.access_sent_at ||= Time.current
      end
    end
  end
end
