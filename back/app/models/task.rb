class Task < ApplicationRecord
  include ::Associations::Task
  include ::Validations::Task
end
