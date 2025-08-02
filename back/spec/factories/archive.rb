FactoryBot.define do
  factory :archive do
    name { :archives }
    record { Task.first || create(:task) }
    blob { ActiveStorage::Blob.first || create(:blob) }
  end
end
