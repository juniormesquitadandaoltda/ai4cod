class Notification < ApplicationRecord
  include ::Associations::Notification
  include ::Validations::Notification
end
