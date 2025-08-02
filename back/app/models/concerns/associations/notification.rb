module Associations
  module Notification
    extend ::ActiveSupport::Concern
    included do
      belongs_to :notificator, counter_cache: true
    end
  end
end
