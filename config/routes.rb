require 'sidekiq/web'
require 'sidetiq/web'
Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'

  devise_for :users, controllers: { passwords: 'users/passwords', registrations: 'users/registrations'}
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

  resources :projects do
    collection do
      get :edit, action: :edit_collection
      get :archived
    end
    member do 
      post :click_archive
    end
    resources :records do
      collection do
        get :share
      end
    end
    resources :collaborators, except: [:edit, :update, :show]
    resource  :collaborators, only: [:edit, :update]
    resources :slack_channels do
      member do
        post :testing
      end
    end
    resources :githubs
  end

  post '/webhooks/:token', to: 'webhooks#webhook_data'

  resources :records, only: [:index] do
    resources :comments
  end

  resources :todos, except: [:show] do
    member do
      post :change_status
    end
    collection do
      post :publish
    end
  end

  resources :project_users, only: [:update]
end
