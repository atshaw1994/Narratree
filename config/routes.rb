# config/routes.rb

Rails.application.routes.draw do
  # Devise routes must come first to ensure they are matched correctly.
  devise_for :users

  root "articles#index"

  get "/about", to: "pages#about"

  resources :articles do
    resources :comments do
      member do
        get "reply_form"
      end
    end
    member do
      post "toggle_save"
      post "like"
      post "unlike"
    end
  end
end
