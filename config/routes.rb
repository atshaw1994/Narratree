# config/routes.rb

Rails.application.routes.draw do
  # Devise routes must come first to ensure they are matched correctly.
  devise_for :users
  resources :users, only: [ :show, :update, :edit ] do
    member do
      post "follow", to: "users#follow"
      post "unfollow", to: "users#unfollow"
    end
  end

  root "articles#index"

  get "/about", to: "pages#about"
  get "/guidelines", to: "pages#guidelines", as: :guidelines

  concern :likeable do
    resources :likes, only: [ :create, :destroy ]
  end

  resources :flags, only: [ :create ]

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
    get "dashboard", to: "dashboard#index"
    resources :users, only: [] do
      post :warn, on: :member
    end
  end

  get "/settings", to: "users#settings", as: :settings
  patch "/settings", to: "users#update_settings"
end
