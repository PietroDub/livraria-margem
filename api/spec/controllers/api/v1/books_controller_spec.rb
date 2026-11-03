require 'rails_helper'

RSpec.describe Api::V1::BooksController, type: :controller do
  render_views

  describe '#index' do
    it 'retorna uma lista de livros' do
      create(:book)

      get :index

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['books']).to be_present
    end

    it 'quando não há livros devolve a lista vazia' do
      get :index

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['books']).to eq([])
    end

    it 'quando filtram livros pelo termo de busca' do
      book = create(:book)

      get :index, params: { q: book.title }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['books'].first['title']).to eq(book.title)
    end

    it 'quando pesquisam um livro pelo isbn' do
      book = create(:book)

      get :index, params: { q: book.isbn }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['books'].first['id']).to eq(book.id)
    end
  end

  describe '#show' do
    it 'retorna um livro' do
      book = create(:book)

      get :show, params: { id: book.id }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['title']).to eq(book.title)
    end

    it 'quando o livro não é encontrado' do
      get :show, params: { id: 999 }

      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)['error']).to eq('Objeto não encontrado.')
    end
  end

  describe '#create' do
    it 'cria um livro' do
      user = create(:user)
      authenticate(user)

      post :create,
           params: { book: { title: 'The Great Gatsby', author: 'F. Scott Fitzgerald', category: 'Ficção',
                             isbn: '9781234567890' } }

      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)['title']).to eq('The Great Gatsby')
      expect(JSON.parse(response.body)['author']).to eq('F. Scott Fitzgerald')
    end

    it 'retorna 422 quando os dados são inválidos' do
      user = create(:user)
      authenticate(user)

      post :create,
           params: { book: { title: '', author: 'F. Scott Fitzgerald', category: 'Ficção', isbn: '9781234567890' } }

      expect(response).to have_http_status(422)
      expect(JSON.parse(response.body)['errors']).to be_present
    end
  end

  describe '#update' do
    it 'atualiza um livro' do
      book = create(:book)
      authenticate(book.user)

      put :update,
          params: { id: book.id, book: { title: 'The Great Gatsby', author: 'F. Scott Fitzgerald' } }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['title']).to eq('The Great Gatsby')
      expect(JSON.parse(response.body)['author']).to eq('F. Scott Fitzgerald')
    end

    it 'quando o livro não é encontrado' do
      user = create(:user)
      authenticate(user)

      put :update,
          params: { id: 999, book: { title: 'The Great Gatsby', author: 'F. Scott Fitzgerald' } }

      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)['error']).to eq('Objeto não encontrado.')
    end

    it 'quando não é autorizado' do
      book = create(:book)
      request.headers['Authorization'] = 'Bearer invalid_token'

      put :update,
          params: { id: book.id, book: { title: 'The Great Gatsby', author: 'F. Scott Fitzgerald' } }

      expect(response).to have_http_status(:unauthorized)
      expect(JSON.parse(response.body)['error']).to eq('Não autenticado.')
    end
  end

  describe '#destroy' do
    it 'remove um livro' do
      book = create(:book)
      authenticate(book.user)

      delete :destroy, params: { id: book.id }

      expect(response).to have_http_status(:no_content)
    end

    it 'quando o livro não é encontrado' do
      user = create(:user)
      authenticate(user)

      delete :destroy, params: { id: 999 }

      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)['error']).to eq('Objeto não encontrado.')
    end
  end
end
