module Associations
  module PaperTrail
    module Version
      extend ::ActiveSupport::Concern
      included do
        include ::PaperTrail::VersionConcern

        self.table_name = :audits

        belongs_to :item, polymorphic: true
        belongs_to :whodunnit, class_name: 'User'
        belongs_to :owner, class_name: 'User', counter_cache: :audits_count
      end
    end
  end
end
