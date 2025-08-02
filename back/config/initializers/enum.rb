require 'active_record/enum'

module ActiveRecord
  module Enum
    class EnumType
      def assert_valid_value(value); end
    end
  end
end
