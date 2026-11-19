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

Quando esses quatro `save` falsos estiverem previsíveis sem olhar o model, o próximo passo é o `update`: `Book.find` devolve o registro, e `update` grava ou devolve `false` com `errors`.
