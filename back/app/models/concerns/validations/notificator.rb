module Validations
  module Notificator
    extend ::ActiveSupport::Concern
    included do
      before_validation :config_token!, on: :create

      validates :name, presence: true, uniqueness: { case_sensitive: false }
      validates :token, presence: true, uniqueness: { case_sensitive: false }
      validates :actived, presence: false

      private

      def config_token!
        self.token ||= Devise.friendly_token(256)
      end
    end
  end
end
