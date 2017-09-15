Rails.application.routes.draw do
  devise_for :users
  resources :users, only: [:index, :show]
  get 'home/index'

  resources :chats, only: [:new, :create, :show, :index] do
    collection do
      get '/start/:user_id', to: 'chats#start', as: :start
    end

    member do
      get '/load_more/:page', to: 'chats#load_more', as: :load_more, defaults: { format: :js }
    end
  end

  root to: 'home#index'

  mount ActionCable.server => '/cable'
end
