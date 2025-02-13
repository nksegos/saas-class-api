Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  post '/signup', to: 'users#create'
  post '/auth/login', to: 'auth#login'
  get '/auth/logout', to: 'auth#logout'

  resources :todos, only: [:index, :create, :show, :update, :destroy] do
    resources :items, controller: 'todo_items', param: :iid, only: [:show, :create, :update, :destroy]
  end
end

