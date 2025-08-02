namespace :public do
  resources :notificators, only: [], param: :token do
    resources :notifications, only: :create
  end
end
