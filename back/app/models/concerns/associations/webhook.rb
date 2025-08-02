module Associations
  module Webhook
    extend ::ActiveSupport::Concern
    included do
      has_paper_trail only: %i[url actived resource event]

      belongs_to :subscription, counter_cache: true
    end
  end
end
