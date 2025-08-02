devise_for :users, skip: :all

namespace :login do
  devise_scope :user do
    resource :session, only: %i[new create update destroy]
    resource :registration, only: %i[edit update destroy]
    resource :unlock, only: %i[new edit create update]
  end
end
