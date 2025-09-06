# config/routes.rb

Rails.application.routes.draw do
  # Devise routes must come first to ensure they are matched correctly.
  devise_for :users

  root "articles#index"

  get "/about", to: "pages#about"

  resources :articles do
    resources :comments
    member do
      post "toggle_save"
      post "like"
      post "unlike"
    end
  end
end
