FactoryBot.define do
  factory :blob, class: 'ActiveStorage::Blob' do
    filename { 'name.txt' }
    content_type { 'text/plain' }
    checksum { 'checksum' }
    byte_size { 100 }
    metadata { { identified: true, analyzed: true } }
  end
end
