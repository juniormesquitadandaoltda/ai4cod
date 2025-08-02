class Field < ApplicationRecord
  include ::Associations::Field
  include ::Validations::Field
end
