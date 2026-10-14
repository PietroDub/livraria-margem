Rails.application.routes.draw do
  get '/up', to: 'rails/health#show'
  namespace :api do
    namespace :v1 do
      resources :books, only: %i[index show create update destroy]
      #criação de rota para users
      resources :users, only: %i[index show create]
      post 'users/login', to: 'users#login'
    end
  end
end
