FactoryBot.define do
  factory :notification do
    url { 'https://ai4cod.com/public/notificators/token/notifications' }
    headers { { key: 'value' } }
    body { { key: 'value' } }
    notificator { create(:notificator) }
  end
end
