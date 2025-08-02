require 'sidekiq/web'

Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?

  authenticate :user, ->(u) { u.profile_admin? } do
    mount Rswag::Ui::Engine => '/admin/swagger'
    mount Rswag::Api::Engine => '/admin/swagger'
    mount Sidekiq::Web => '/admin/sidekiq'
  end

  scope :data do
    defaults format: :json do
      root 'home#index', as: :home

      draw(:admin)
      draw(:standard)
      draw(:login)
      draw(:public)
    end
  end
end
