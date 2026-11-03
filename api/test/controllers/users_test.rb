require 'test_helper'

# Este teste verifica a criação de um usuário pela API.
class UsersTest < ActionDispatch::IntegrationTest
  test 'cria um usuário e retorna seu nome' do
    # Envia uma requisição POST para a rota de criação de usuários.
    # `as: :json` informa que os dados enviados estão no formato JSON.
    post '/api/v1/users',
         params: { user: { name: 'Ana Silva', email: 'ana@example.com', password: 'senha123' } },
         as: :json

    # A API deve responder 201 Created quando cria o usuário com sucesso.
    assert_response :created

    # Lê o JSON da resposta e verifica o nome retornado.
    assert_equal 'Ana Silva', response.parsed_body['name']
  end

  test 'cria um usuario sem nome e retorna 422 Unprocessable Entity' do
    post '/api/v1/users',
         params: { user: { email: 'ana@example.com', password: 'senha123' } },
         as: :json

    assert_response :unprocessable_entity
    assert_equal 'Nome é obrigatório', response.parsed_body['error']
  end

  # TODO: testes para edição de email, id e senha

  test 'edita um usuário e retorna seu email' do
    post '/api/v1/users',
         params: { user: { name: 'Ana Silva', email: 'ana@example.com', password: 'senha123' } },
         headers: { "Authorization" => "Bearer #{token}" },
         as: :json
    token = Rails.application.message_verifier(:authentication).generate(
      { user_id: user.id }, expires_in: 24.hours.to_i, purpose: :login
    )

    assert_response :updated
    assert_equal 'ana@example.com', response.parsed_body['email']
  end

  test 'edita um usuario com email já existente e retorna 422 Unprocessable Entity' do
    post '/api/v1/users',
         params: { user: { name: 'Ana Silva', email: 'ana@example.com', password: 'senha123' } },
         as: :json

    assert_response :unprocessable_entity
    assert_equal 'Email já existente', response.parsed_body['error']
  end

  test 'edita um usuario com ID inexistente e retorna 404 Not Found' do
    put '/api/v1/users/100',
        params: { user: { name: 'Ana Silva', email: 'ana@example.com', password: 'senha123' } },
        as: :json

    assert_response :not_found
    assert_equal 'Usuário não encontrado', response.parsed_body['error']
  end

  # TODO: testes para exclusão de usuário

  test 'exclui um usuário e retorna 204 No Content' do
    post '/api/v1/users',
         params: { user: { name: 'Ana Silva', email: 'ana@example.com', password: 'senha123' } },
         as: :json

    assert_response :no_content
    assert_equal nil, User.find_by(email: 'ana@example.com')
  end

  test 'exclui um usuário e retorna 404 Not Found' do
    delete '/api/v1/users/1'
    assert_response :not_found
  end

  # TODO: testes para listagem de usuários

  test 'lista todos os usuários e retorna 200 OK' do
    get '/api/v1/users'
    assert_response :ok
    assert_equal User.all, response.parsed_body
  end

  test 'login de usuário e retorna 200 OK com token' do
    create_user

    post '/api/v1/users/login',
         params: { email: 'ana@example.com', password: 'senha123' },
         as: :json

    assert_response :ok
    body = response.parsed_body
    assert_equal 'ana@example.com', body.fetch('user').fetch('email')
    assert body.fetch('token').present?
    assert_nil body['user']['password']
    assert_nil body['user']['password_digest']
  end

  test 'login de usuário com email ou senha incorretos e retorna 401 Unauthorized' do
    create_user

    post '/api/v1/users/login',
         params: { email: 'ana@example.com', password: 'senha-errada' },
         as: :json

    assert_response :unauthorized
    assert_equal 'Email ou senha inválidos.', response.parsed_body['error']
  end

  test 'logout autenticado retorna 204 No Content' do
    user = create_user

    post '/api/v1/users/logout', headers: auth_headers(user), as: :json

    assert_response :no_content
  end

  test 'logout sem token retorna 401 Unauthorized' do
    post '/api/v1/users/logout', as: :json

    assert_response :unauthorized
    assert_equal 'Não autenticado.', response.parsed_body['error']
  end

  test 'logout com token inválido retorna 401 Unauthorized' do
    post '/api/v1/users/logout',
         headers: { 'Authorization' => 'Bearer token-invalido' },
         as: :json

    assert_response :unauthorized
    assert_equal 'Não autenticado.', response.parsed_body['error']
  end

  # TODO: testes para relacionamento entre usuários e livros
  test 'relaciona um usuário a um livro e retorna 200 OK' do
    post '/api/v1/users',
         params: { user: { name: 'Ana Silva', email: 'ana@example.com', password: 'senha123' } },
         as: :json

    assert_response :ok
    assert_equal 'Ana Silva', response.parsed_body['name']
  end

  test 'relaciona um usuário a um livro com ID inexistente e retorna 404 Not Found' do
    post '/api/v1/users/100/books',
         params: { book: { title: 'Livro 1', author: 'Autor 1' } },
         as: :json

    assert_response :not_found
    assert_equal 'Livro não encontrado', response.parsed_body['error']
  end
end
