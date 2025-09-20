# config/routes.rb

Rails.application.routes.draw do
  devise_for :users

  resources :users, only: [ :show, :update, :edit, :destroy ] do
    member do
      post "follow", to: "users#follow"
      post "unfollow", to: "users#unfollow"
    end
  end

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
    get "dashboard", to: "dashboard#index"
    resources :users, only: [ :index, :destroy ] do
      post :warn, on: :member
      member do
        patch :approve
        delete :reject
      end
    end
    resources :articles, only: [ :index, :destroy ]
  end

  root "articles#index"
  get "/about", to: "pages#about"
  get "/guidelines", to: "pages#guidelines", as: :guidelines
  get "/settings", to: "users#settings", as: :settings
  patch "/settings", to: "users#update_settings"
end
