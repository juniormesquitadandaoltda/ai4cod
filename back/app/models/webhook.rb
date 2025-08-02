class Webhook < ApplicationRecord
  include ::Associations::Webhook
  include ::Validations::Webhook
end
