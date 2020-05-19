Rails.application.routes.draw do
  get 'sessions/new'
  root 'tasks#index'

  resources :tasks, except: [:index] do
    collection do
      post :sort
      get :search
    end
  end

  resources :sessions, only: [:new, :create, :destroy]
  resources :users, only: [:new, :create, :show]
end
