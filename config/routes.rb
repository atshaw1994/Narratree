# config/routes.rb

Rails.application.routes.draw do
  # Devise routes must come first to ensure they are matched correctly.
  devise_for :users
  resources :users, only: [ :show, :update, :edit ]

  root "articles#index"

  get "/about", to: "pages#about"

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
  end
end
