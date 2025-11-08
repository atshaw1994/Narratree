# config/routes.rb

Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "users/registrations", confirmations: "users/confirmations" }

  resources :users, only: [ :update, :destroy ] do
    collection do
      get "search", to: "users#search"
    end
    member do
      post "follow", to: "users#follow"
      post "unfollow", to: "users#unfollow"
    end
  end

  get "/users/:username", to: "users#show", as: :user_profile

  resources :flags, only: [ :create ]

  concern :likeable do
    resources :likes, only: [ :create, :destroy ]
  end

  resources :articles do
    resources :comments, concerns: :likeable do
      member do
        get "reply_form"
      end
    end
    member do
      post "toggle_save"
      post "like"
      post "unlike"
      delete "remove_photo/:photo_id", to: "articles#remove_photo", as: :remove_photo
    end
  end

  namespace :admin do
    get "tickers/index"
    get "dashboard", to: "dashboard#index"
    resources :users, only: [ :index, :destroy ] do
      patch :update_role, on: :member
      post :warn, on: :member
      member do
        get :approve
        patch :approve
        get :reject
        delete :reject
      end
    end
    resources :articles, only: [ :index, :destroy ]
    resources :tickers
      resources :admin_votes, only: [ :index, :show, :create ] do
        member do
          post :vote
          get :results
          patch :owner_decide
        end
      end
  end

  resources :ticker_messages, only: [ :create, :destroy ]

  get "sitemap.xml", to: "sitemap#index", defaults: { format: "xml" }
  root "articles#index"
  get "/about", to: "pages#about"
  get "/guidelines", to: "pages#guidelines", as: :guidelines
  get "/settings", to: "users#settings", as: :settings
  patch "/settings", to: "users#update_settings"
end
