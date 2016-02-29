require 'sidekiq/web'
require 'sidetiq/web'
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
    member do
      get :setting
      put :setting, action: "update_setting"
    end
    collection do
      get :edit, action: :edit_collection
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
  end

  resources :records, only: [:index] do
    resources :comments
  end

  resources :todos, except: [:show] do
    member do
      post :toggle_done
    end
  end

  resources :project_users, only: [:update]
end
