# Comandos e o que fazer com o create

Cola de operação da Margem. O `create` de `BooksController` já está entendido: `Book.new` monta o objeto, `save` valida e grava, sucesso responde 201, falha responde 422 com `errors`.

## Subir com Docker

Na raiz do repositório. Sobe a API em http://localhost:3001 e o site em http://localhost:3000. O container da API já roda `db:prepare` e `db:seed`. O banco fica no volume `books_data`.

```sh
docker compose up --build
```

`--build` reconstrói a imagem e reaproveita o cache das camadas que não mudaram. Para ignorar o cache:

```sh
docker compose build --no-cache
docker compose up
```

Parar os containers:

```sh
docker compose down
```

Parar e apagar o banco do volume:

```sh
docker compose down -v
```

Console, com os containers no ar:

```sh
docker compose exec api bundle exec rails console
```

## Subir sem Docker

Na pasta `api`. O banco é o arquivo `db/development.sqlite3`. Não há servidor de banco separado.

```sh
cd api
bundle install
bundle exec rails db:prepare
bundle exec rails db:seed
bundle exec rails server -p 3001
```

Console, em outro terminal, ainda em `api`:

```sh
bundle exec rails console
```

O frontend, na raiz do repositório: `npm ci` e `npm run dev`.

## Testes

Dentro do container:

```sh
docker compose exec api bundle exec rspec
docker compose exec api bundle exec rails db:prepare RAILS_ENV=test
docker compose exec api bundle exec rails test
```

Na pasta `api`, sem Docker:

```sh
bundle exec rspec
bundle exec rspec spec/controllers/api/v1/books_controller_spec.rb
bundle exec rails db:prepare RAILS_ENV=test
bundle exec rails test
```

`rspec` é a suíte de `api/spec`. O `rails_helper` força `RAILS_ENV=test` e usa `db/test.sqlite3`. Cada exemplo desfaz o que ele mesmo gravou. `rails test` é a suíte de `api/test`.

## O que fazer com o create

No console, com a API já no ar. Um cadastro que passa:

```ruby
book = Book.new(
  title: 'Dom Casmurro',
  author: 'Machado de Assis',
  category: 'Literatura brasileira',
  isbn: '9780000000001',
  price_cents: 3990,
  stock: 2
)
book.id    # nil
book.save  # true
book.id    # número
```

`Book.create` faz `new` e `save` numa chamada só. `Book.create!` grava ou levanta `ActiveRecord::RecordInvalid`.

Quatro gravações que o model recusa. Em cada uma, `save` devolve `false` e `book.errors.full_messages` explica o motivo.

```ruby
Book.new(title: '', author: 'Machado de Assis', category: 'Ficção', isbn: '9780000000002').save
Book.new(title: 'Outro', author: 'Machado de Assis', category: 'Romance', isbn: '9780000000003').save
Book.new(title: 'Outro', author: 'Machado de Assis', category: 'Ficção', isbn: '9780000000001').save
Book.new(title: 'Outro', author: 'Machado de Assis', category: 'Ficção', isbn: '9780000000004', stock: -1).save
```

A categoria precisa ser uma de `Book::CATEGORIES`. O ISBN tem 10 ou 13 dígitos e é único. Estoque e preço não podem ser negativos.

Pela API, `POST /api/v1/books` exige Bearer e o envelope `{ "book": { ... } }`. Título vazio responde 422 com `errors`. O mesmo caminho está nos exemplos `cria um livro` e `retorna 422 quando os dados são inválidos` de `books_controller_spec.rb`.

## O que fazer com o update

`PATCH /api/v1/books/:id` passa por `set_book`, que faz `Book.find`. Id inexistente responde 404 com `"Objeto não encontrado."` e o `update` nem roda. A action exige Bearer.

Com o livro encontrado, `@book.update(book_params)` altera os campos permitidos e grava. `true` responde 200 com o livro. `false` responde 422 com `errors`, e o banco fica como estava.

No console, use o id do livro que o `create` gravou:

```ruby
book = Book.find(1)
book.update(title: 'Memórias póstumas')  # true
book.title                                   # título novo

book.update(title: '')                       # false
book.errors.full_messages
book.reload.title                            # o título anterior continua no banco

book.update(stock: -1)                       # false
book.update(isbn: '9780000000001')           # false, se outro livro já tem esse ISBN
```

`update` é atribuir e dar `save`. `update!` grava ou levanta `ActiveRecord::RecordInvalid`.

## O que fazer com o destroy

`DELETE /api/v1/books/:id` também passa por `set_book`. Id inexistente responde 404 com `"Objeto não encontrado."`. A action exige Bearer.

Com o livro encontrado, `@book.destroy!` apaga a linha. `head :no_content` responde 204 sem corpo. Não há 422: ou apaga, ou o `find` já respondeu 404.

No console, use um livro que você criou no exercício, não um do seed:

```ruby
book = Book.find(1)
book.destroy!
book.destroyed?   # true
Book.find(1)      # ActiveRecord::RecordNotFound
```

`destroy` também apaga. `destroy!` apaga ou levanta `ActiveRecord::RecordNotDestroyed`. Nesse model os dois concluem a exclusão.

Apagar um usuário apaga os livros dele: `User` tem `has_many :books, dependent: :destroy`. O ciclo do livro fecha aqui: criar, atualizar, apagar.
