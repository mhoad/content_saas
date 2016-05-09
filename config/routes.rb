require 'constraints/subdomain_required'

Rails.application.routes.draw do
  devise_for :users

  constraints(SubdomainRequired) do
    scope module: "accounts" do
      root to: "websites#index", as: :account_root
      
      get "/account/choose_plan", to: "plans#choose", as: :choose_plan
      patch "/account/choose_plan", to: "plans#chosen"
      delete "/account/cancel", to: "plans#cancel", as: :cancel_subscription
      
      resources :websites
      resources :invitations, only: [:new, :create] do
        member do
          get :accept
          patch :accepted
        end
      end
      resources :users, only: [:index, :destroy]
    end
  end

  root to: "home#index"

  get "/accounts/new", to: "accounts#new", as: :new_account
  post "/accounts", to: "accounts#create", as: :accounts

  get "signed_out", :to => "users#signed_out"
end
