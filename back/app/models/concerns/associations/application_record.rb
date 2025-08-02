module Associations
  module ApplicationRecord
    extend ::ActiveSupport::Concern
    included do
      primary_abstract_class
    end
  end
end
