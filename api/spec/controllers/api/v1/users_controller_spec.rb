require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  describe '#index' do
    it 'retorna dois usuários' do
      usuarios = create_list(:user, 2)
      authenticate(usuarios.first)

      get :index

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(2)
    end
  end

  describe '#create' do
    it 'cria um usuário' do
      post :create, params: { user: { name: 'John Doe', email: 'john.doe@example.com', password: 'password' } }

      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)['name']).to eq('John Doe')
      expect(JSON.parse(response.body)['email']).to eq('john.doe@example.com')
    end

    it 'quando o usuário não é criado' do
      post :create, params: { user: { name: 'Jo', email: 'john.doe@example.com', password: 'password' } }

      expect(response).to have_http_status(422)
      expect(JSON.parse(response.body)['errors']).to be_present
    end
  end

  describe '#show' do
    it 'retorna um usuário' do
      user = create(:user)
      authenticate(user)

      get :show, params: { id: user.id }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['name']).to eq(user.name)
      expect(JSON.parse(response.body)['email']).to eq(user.email)
    end
  end

  describe '#update' do
    it 'atualiza um usuário' do
      user = create(:user)
      authenticate(user)

      put :update,
          params: { id: user.id, user: { name: 'John Doe', email: 'john.doe@example.com', password: 'password' } }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['name']).to eq('John Doe')
      expect(JSON.parse(response.body)['email']).to eq('john.doe@example.com')
    end

    it 'quando o usuário não é encontrado' do
      user = create(:user)
      authenticate(user)

      put :update,
          params: { id: 999, user: { name: 'John Doe', email: 'john.doe@example.com', password: 'password' } }

      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)['error']).to eq('Objeto não encontrado.')
    end
  end

  describe '#destroy' do
    it 'remove um usuário' do
      user = create(:user)
      authenticate(user)

      delete :destroy, params: { id: user.id }

      expect(response).to have_http_status(:no_content)
    end

    it 'quando o usuário não é encontrado' do
      user = create(:user)
      authenticate(user)

      delete :destroy, params: { id: 999 }

      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)['error']).to eq('Objeto não encontrado.')
    end
  end

  describe '#login' do
    it 'retorna um token quando as credenciais são válidas' do
      user = create(:user)

      post :login, params: { email: user.email, password: 'senha-segura-123' }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['token']).to be_present
    end

    it 'retorna não autorizado quando as credenciais são inválidas' do
      post :login, params: { email: 'incorrect@example.com', password: 'incorrect' }

      expect(response).to have_http_status(:unauthorized)
      expect(JSON.parse(response.body)['error']).to eq('Email ou senha inválidos.')
    end
  end

  describe '#logout' do
    it 'encerra a sessão do usuário' do
      user = create(:user)
      authenticate(user)

      post :logout

      expect(response).to have_http_status(:no_content)
    end
  end
end
