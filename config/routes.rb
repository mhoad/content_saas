Rails.application.routes.draw do
  root to: "home#index"
  
  get "/accounts/new", to: "accounts#new", as: :new_account
  post "/accounts", to: "accounts#create", as: :accounts
end
