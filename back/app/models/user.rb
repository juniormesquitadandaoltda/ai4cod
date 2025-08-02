class User < ApplicationRecord
  include ::Associations::User
  include ::Validations::User
end
