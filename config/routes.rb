Rails.application.routes.draw do
  namespace :admin do
    get 'users/new'
  end
  get 'sessions/new'
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
end
