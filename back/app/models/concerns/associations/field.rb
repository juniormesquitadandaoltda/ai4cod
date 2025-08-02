module Associations
  module Field
    extend ::ActiveSupport::Concern
    included do
      has_paper_trail only: %i[values]

      belongs_to :subscription, counter_cache: true
    end
  end
end
