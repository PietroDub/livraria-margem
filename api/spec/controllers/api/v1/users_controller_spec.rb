require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  describe "#index" do
    it "retorna dois usuários" do
      usuarios = create_list(:user, 2)
      token = Rails.application.message_verifier(:authentication).generate(
        { user_id: usuarios.first.id }, expires_in: 24.hours.to_i, purpose: :login
      )

      get :index, headers: { "Authorization" => "Bearer #{token}" }

      expect(response).to have_http_status(:ok)

      users = JSON.parse(response.body)
      expect(users.size).to eq(2)
    end
  end

  describe "#create" do
    it "cria um usuário" do
      post :create, params: { user: { name: "John Doe", email: "john.doe@example.com", password: "password" } }

      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)["name"]).to eq("John Doe")
      expect(JSON.parse(response.body)["email"]).to eq("john.doe@example.com")
    end

    it "quando o usuário não é criado" do
      post :create, params: { user: { name: "John Doe", email: "john.doe@example.com", password: "password" } }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)["error"]).to eq("User not created")
    end
  end

  describe "#show" do
    it "retorna um usuário" do
      user = create(:user)
      token = Rails.application.message_verifier(:authentication).generate(
        { user_id: user.id }, expires_in: 24.hours.to_i, purpose: :login
      )

      get :show, params: { id: user.id }, headers: { "Authorization" => "Bearer #{token}" }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["name"]).to eq(user.name)
      expect(JSON.parse(response.body)["email"]).to eq(user.email)
    end
  end

  describe "#update" do
    it "atualiza um usuário" do
      user = create(:user)
      token = Rails.application.message_verifier(:authentication).generate(
        { user_id: user.id }, expires_in: 24.hours.to_i, purpose: :login
      )

      put :update,
          params: { id: user.id, user: { name: "John Doe", email: "john.doe@example.com", password: "password" } },
          headers: { "Authorization" => "Bearer #{token}" }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["name"]).to eq("John Doe")
      expect(JSON.parse(response.body)["email"]).to eq("john.doe@example.com")
    end

    it "quando o usuário não é encontrado" do
      user = create(:user)
      token = Rails.application.message_verifier(:authentication).generate(
        { user_id: user.id }, expires_in: 24.hours.to_i, purpose: :login
      )

      put :update,
          params: { id: 999, user: { name: "John Doe", email: "john.doe@example.com", password: "password" } },
          headers: { "Authorization" => "Bearer #{token}" }

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "#destroy" do
    it "remove um usuário" do
      user = create(:user)
      token = Rails.application.message_verifier(:authentication).generate(
        { user_id: user.id }, expires_in: 24.hours.to_i, purpose: :login
      )

      delete :destroy,
             params: { id: user.id },
             headers: { "Authorization" => "Bearer #{token}" }

      expect(response).to have_http_status(:no_content)
    end

    it "quando o usuário não é encontrado" do
      user = create(:user)
      token = Rails.application.message_verifier(:authentication).generate(
        { user_id: user.id }, expires_in: 24.hours.to_i, purpose: :login
      )

      delete :destroy,
             params: { id: 999 },
             headers: { "Authorization" => "Bearer #{token}" }

      expect(response).to have_http_status(:not_found)
    end
  end

  # describe "#me" do
  #   it "retorna o usuário atual" do
  #     user = create(:user)

  #     get :me, params: { id: user.id }

  #     expect(response).to have_http_status(:ok)
  #     expect(JSON.parse(response.body)["name"]).to eq(user.name)
  #     expect(JSON.parse(response.body)["email"]).to eq(user.email)
  #   end
  # end

  describe "#login" do
    context "quando as credenciais são válidas" do
      it "retorna um token" do
        user = create(:user)

        post :login, params: {
          email: user.email,
          password: user.password
        }

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)["token"]).to be_present
      end
    end

    context "quando as credenciais são inválidas" do
      it "retorna não autorizado" do
        post :login, params: {
          email: "incorrect@example.com",
          password: "incorrect"
        }

        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)["error"]).to eq("Email ou senha inválidos.")
      end
    end
  end

  describe "#logout" do
    it "encerra a sessão do usuário" do
      user = create(:user)
      token = Rails.application.message_verifier(:authentication).generate(
        { user_id: user.id }, expires_in: 24.hours.to_i, purpose: :login
      )

      post :logout, params: { id: user.id }, headers: { "Authorization" => "Bearer #{token}" }

      expect(response).to have_http_status(:no_content)
    end

    it "responde sem conteúdo quando recebe um token válido" do
      user = create(:user)
      token = Rails.application.message_verifier(:authentication).generate(
        { user_id: user.id }, expires_in: 24.hours.to_i, purpose: :login
      )

      post :logout, headers: { "Authorization" => "Bearer #{token}" }

      expect(response).to have_http_status(:no_content)
    end
  end
end
