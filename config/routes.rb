Rails.application.routes.draw do
  resources :users
  root "articles#index"

  # Routes for the login session
  get "/login", to: "sessions#new", as: "login"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy", as: "logout"

  get "/about", to: "pages#about"
  get "/signup", to: "sessions#new"

  resources :articles do
    resources :comments
    member do
      post "toggle_save"
    end
  end
end
