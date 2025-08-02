class Archive < ActiveStorage::Attachment
  include ::Associations::Archive
  include ::Validations::Archive
end
