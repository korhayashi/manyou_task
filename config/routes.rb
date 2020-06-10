Rails.application.routes.draw do
  root 'tasks#index'

  resources :tasks, except: [:index] do
    collection do
      get :sort
      get :search
    end
  end

  resources :sessions, only: [:new, :create, :destroy]
  resources :users, only: [:new, :create, :show]

  namespace :admin do
    resources :users, except: [:show]
  end

  resources :labels, only: [:new, :create]
end
