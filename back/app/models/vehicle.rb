class Vehicle < ApplicationRecord
  include ::Associations::Vehicle
  include ::Validations::Vehicle
end
