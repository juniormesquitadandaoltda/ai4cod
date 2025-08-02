namespace :standard do
  resource :session, only: %i[show]
  resource :subscription, only: %i[show]

  resources :audits, only: %i[index show]
  resources :users, only: %i[index]

  %i[
    calleds
    collaborators
    webhooks
    fields
    proprietors
    facilitators
    vehicles
    tasks
    archives
  ].each do |name|
    resources name
  end

  %i[
    fields
  ].each do |name|
    resources name, only: %i[index show edit update]
  end
end
