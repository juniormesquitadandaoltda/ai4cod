namespace :admin do
  resources :swagger, only: :show, path: 'swagger/:version', param: 'file'
  resource :session, only: %i[show]
  resources :users, only: %i[index show edit update] do
    put :personificate, on: :member
  end

  resources :subscriptions
  resources :audits, only: %i[index show]
  resources :notificators
  resources :calleds, only: %i[index show edit update]

  %i[
    notifications
    collaborators
    webhooks
    fields
    proprietors
    facilitators
    vehicles
    tasks
    archives
  ].each do |name|
    resources name, only: %i[index show]
  end
end
