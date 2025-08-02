module Validations
  module Notification
    extend ::ActiveSupport::Concern
    included do
      validates :url, presence: true
      validates :headers, presence: true
      validates :body, presence: true

      validates :notificator, presence: true, persistence: true, unchange: true
    end
  end
end
