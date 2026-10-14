Rails.application.routes.draw do
  # Health check do Rails (não é endpoint da livraria).
  # testa se o rails está funcionando
  get '/up', to: 'rails/health#show'

  # Prefixo /api/v1 e módulos Api::V1::...
  namespace :api do
    namespace :v1 do
      # CRUD REST de livros; only: evita new/edit (HTML).
      resources :books, only: %i[index show create update destroy]

      # Users: listar, ver, criar, atualizar e deletar.
      resources :users, only: %i[index show create update destroy]
      # Fora do REST: POST /api/v1/users/login → UsersController#login
      post 'users/login', to: 'users#login'
      # Fora do REST: POST /api/v1/users/logout → UsersController#logout
      post 'users/logout', to: 'users#logout' 
    end
  end
end
