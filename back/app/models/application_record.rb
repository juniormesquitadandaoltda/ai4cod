class ApplicationRecord < ActiveRecord::Base
  include ::Associations::ApplicationRecord
  include ::Validations::ApplicationRecord
end
