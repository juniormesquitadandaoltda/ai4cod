module PaperTrail
  class Version < ActiveRecord::Base
    include ::Associations::PaperTrail::Version
    include ::Validations::PaperTrail::Version
  end
end
