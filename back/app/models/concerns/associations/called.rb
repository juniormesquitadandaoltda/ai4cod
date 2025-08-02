module Associations
  module Called
    extend ::ActiveSupport::Concern
    included do
      has_paper_trail

      belongs_to :subscription, counter_cache: true
    end
  end
end
