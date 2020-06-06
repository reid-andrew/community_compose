Rails.application.routes.draw do
  root to: 'welcome#index'
  # root to: "videopages#home"

  # get 'videopages/home'

  get '/auth/flat/callback', to: 'sessions#create'

  delete '/logout', to: 'sessions#destroy', as: :logout

  namespace :users do
    resources :dashboard, only: [:index]
    resources :explore, only: [:index]
    get '/location/:id/edit', to: 'location#edit', as: :edit_location
    patch '/location/:id', to: 'location#update', as: :location
    get '/profile/:id/edit', to: 'profile#edit', as: :edit_profile
    patch '/profile/:id', to: 'profile#update', as: :profile

    resources :conversations do
      resources :messages
    end
  end

  resources :scores, only: [:index, :new, :create, :update, :destroy]

  resources :scores, only: [:index, :new, :create, :destroy]
  resources :requests, only: [:create, :destroy]

  resources :users, only: [:show, :edit, :update, :new, :create]
end
