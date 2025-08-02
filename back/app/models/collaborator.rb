class Collaborator < ApplicationRecord
  include ::Associations::Collaborator
  include ::Validations::Collaborator
end
