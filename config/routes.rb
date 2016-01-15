require 'sidekiq/web'
Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'

  devise_for :users
  # omniauth
  get "/authorizations/:provider/callback", to: "authorizations#callback"
  get "/authorizations/failure" => "authorizations#failue", as: :auth_failure
  Setting.omniauth.providers.keys.each do |provider|
    get "/authorizations/#{provider}", as: "auth_#{provider}"
  end

  root to: "base#index"
  get '/robots.txt', to: "base#robots", defaults: { format: "text" }

  namespace :admin do
    root to: "base#index"
    resources :users
    resources :categories do
      member do
        get :revisions
        post :restore
      end
    end
  end

  resources :projects, except: :destroy do
    resources :records
    resources :collaborators, except: [:edit, :update, :show]
  end

  resources :records, only: [] do
    resources :comments
  end
end
