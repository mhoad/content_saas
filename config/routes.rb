Rails.application.routes.draw do
  devise_for :users
  root to: "home#index"
  
  get "/accounts/new", to: "accounts#new", as: :new_account
  post "/accounts", to: "accounts#create", as: :accounts
end
