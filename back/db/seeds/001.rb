return if Task.any?

admin = User.new(
  email: 'admin@ai4cod.com',
  confirmed_at: Time.current,
  policy_terms: true
)
class << admin
  private

  def after_create_subscription_free!; end
end
admin.save!
admin.profile_admin!
p "create admin: #{admin.id}"

standard_1 = User.create!(
  email: 'standard+1@ai4cod.com',
  confirmed_at: Time.current,
  policy_terms: true
)
p "create standard_1: #{standard_1.id}"

standard_2 = User.create!(
  email: 'standard+2@ai4cod.com',
  confirmed_at: Time.current,
  policy_terms: true
)
p "create standard_2: #{standard_2.id}"

subscription_1 = Subscription.create!(
  actived: true,
  name: 'Standard+1',
  user: standard_1,
  due_date: Date.current.end_of_year,
  maximum_records_count: 1_000
)
p "create subscription_1: #{subscription_1.id}"

notificator = Notificator.create!(
  name: 'Notificator',
  actived: true,
  token: 'X8WaUC6yi29wGaDHHBsSywVQdQ7rRNeDqTwUVwQ15CaRuE5QScByvfPmx3CjPYzMqeVVanfGRAjHGbJbhbSHA1fkoMnXsPtyHEVmwAWcE71wrWucXgpeZUs4UxuQVtQmyXYNtWG4D7NLkNvq5e5dL3vqQ5nN9BDSHE69ST7gfJfuFcdkqNZavNvTv1QN8ZGqKGWM5JryenpFbq33ZEi6CFUBVneUw1zrK8jVEBbLhjyjGSzwgara4CrKpRCicUgm'
)
p "create notificator: #{notificator.id}"

notification = Notification.create!(
  url: "http://dockerhost:3004/data/public/notificators/#{notificator.token}/notifications",
  headers: { key: 'value' },
  body: { key: 'value' },
  notificator:
)
p "create notification: #{notification.id}"

collaborator = Collaborator.create!(
  actived: true,
  user: standard_2,
  subscription: subscription_1
)
p "create collaborator: #{collaborator.id}"

webhook = Webhook.create!(
  actived: true,
  url: "http://dockerhost:3004/data/public/notificators/#{notificator.token}/notifications",
  event: :update,
  resource: :collaborator,
  subscription: subscription_1
)
p "create webhook: #{webhook.id}"

called = Called.create!(
  subject: 'Subject',
  message: 'Message',
  subscription: subscription_1
)
p "create called: #{called.id}"

proprietor = Proprietor.create!(
  name: 'Proprietor',
  email: 'proprietor+01@ai4cod.com',
  subscription: subscription_1,
  archives: [
    { io: File.open('./spec/support/files/image.png'), filename: 'image.png' }
  ]
)
p "create proprietor: #{proprietor.id}"

facilitator = Facilitator.create!(
  name: 'Facilitator',
  email: 'facilitator+01@ai4cod.com',
  subscription: subscription_1,
  archives: [
    { io: File.open('./spec/support/files/image.png'), filename: 'image.png' }
  ]
)
p "create facilitator: #{facilitator.id}"

STANDARD::SubscriptionsService.new(
  subscription: subscription_1
).call
p "update subscription_1: #{subscription_1.id}"

vehicle = Vehicle.create!(
  chassis: '0123456789',
  year: '2024/2025',
  brand: 'FIAT',
  model: 'MOBI',
  color: 'Branco',
  fuel: 'Flex',
  category: 'Passeio',
  kind: 'Automóvel',
  seats: 5,
  plate: 'ABC12345',
  renavam: '9999',
  licensing: '2025/2026',
  notes: 'Financiado',
  subscription: subscription_1,
  archives: [
    { io: File.open('./spec/support/files/image.png'), filename: 'image.png' }
  ]
)
p "create vehicle: #{vehicle.id}"

task = Task.create!(
  name: 'Emplacamento',
  stage: 'Inicial',
  next_stage: 'Vistoria',
  scheduling_at: '2025-01-01 09:00:00',
  shared: true,
  vehicle:,
  facilitator:,
  proprietor:,
  notes: '1º Emplacamento',
  subscription: subscription_1,
  archives: [
    { io: File.open('./spec/support/files/image.png'), filename: 'image.png' }
  ]
)
p "create task: #{task.id}"
