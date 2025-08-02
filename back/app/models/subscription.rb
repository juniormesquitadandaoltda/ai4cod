class Subscription < ApplicationRecord
  include ::Associations::Subscription
  include ::Validations::Subscription
end
