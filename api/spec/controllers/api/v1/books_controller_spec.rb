require 'rails_helper'

RSpec.describe Api::V1::BooksController, type: :controller do
  describe "#index" do
    it "retorna uma lista de livros" do
      get :index

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["books"]).to be_present
    end

    it "quando os livros não são encontrados" do
      get :index

      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)["error"]).to eq("Books not found")
    end
  end

  describe "#show" do
    it "retorna um livro" do
      book = create(:book)

      get :show, params: { id: book.id }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["title"]).to eq(book.title)
    end

    it "quando o livro não é encontrado" do
      get :show, params: { id: 999 }

      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)["error"]).to eq("Book not found")
    end
  end

  describe "#create" do
    it "cria um livro" do
      user = create(:user)
      token = Rails.application.message_verifier(:authentication).generate(
        { user_id: user.id }, expires_in: 24.hours.to_i, purpose: :login
      )

      post :create,
           params: { book: { title: "The Great Gatsby", author: "F. Scott Fitzgerald", category: "Ficção",
                             isbn: "9781234567890" } },
           headers: { "Authorization" => "Bearer #{token}" }

      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)["title"]).to eq("The Great Gatsby")
      expect(JSON.parse(response.body)["author"]).to eq("F. Scott Fitzgerald")
    end
  end

  describe "#update" do
    it "atualiza um livro" do
      book = create(:book)
      token = Rails.application.message_verifier(:authentication).generate(
        { user_id: book.user.id }, expires_in: 24.hours.to_i, purpose: :login
      )

      put :update,
          params: { id: book.id, book: { title: "The Great Gatsby", author: "F. Scott Fitzgerald" } },
          headers: { "Authorization" => "Bearer #{token}" }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["title"]).to eq("The Great Gatsby")
      expect(JSON.parse(response.body)["author"]).to eq("F. Scott Fitzgerald")
    end

    it "quando o livro não é encontrado" do
      user = create(:user)
      token = Rails.application.message_verifier(:authentication).generate(
        { user_id: user.id }, expires_in: 24.hours.to_i, purpose: :login
      )

      put :update,
          params: { id: 999, book: { title: "The Great Gatsby", author: "F. Scott Fitzgerald" } },
          headers: { "Authorization" => "Bearer #{token}" }

      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)["error"]).to eq("Objeto não encontrado.")
    end
  end

  describe "#destroy" do
    it "remove um livro" do
      book = create(:book)
      token = Rails.application.message_verifier(:authentication).generate(
        { user_id: book.user.id }, expires_in: 24.hours.to_i, purpose: :login
      )

      delete :destroy,
             params: { id: book.id },
             headers: { "Authorization" => "Bearer #{token}" }

      expect(response).to have_http_status(:no_content)
    end

    it "quando o livro não é encontrado" do
      user = create(:user)
      token = Rails.application.message_verifier(:authentication).generate(
        { user_id: user.id }, expires_in: 24.hours.to_i, purpose: :login
      )

      delete :destroy,
             params: { id: 999 },
             headers: { "Authorization" => "Bearer #{token}" }

      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)["error"]).to eq("Objeto não encontrado.")
    end
  end
end
