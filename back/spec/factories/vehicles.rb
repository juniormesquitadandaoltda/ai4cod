FactoryBot.define do
  factory :vehicle do
    chassis { '1234567890' }
    year { '2024/2025' }
    brand { 'FIAT' }
    model { 'MOBI' }
    color { 'Branco' }
    fuel { 'Flex' }
    category { 'Passeio' }
    kind { 'Automóvel' }
    seats { 5 }
    plate { 'ABC12345' }
    renavam { '9999' }
    licensing { '2025/2026' }
    notes { 'Financiado' }
    subscription { Subscription.first || create(:subscription) }
  end
end
