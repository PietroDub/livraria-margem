# Aprendendo Ruby com a Margem

## 1. Ruby antes de Rails

Ruby é a linguagem; Rails é o framework web. Arquivos usam snake_case (`books_controller.rb`), classes usam CamelCase (`BooksController`). Indentação convencional: dois espaços. `end` encerra classes, métodos e blocos.

```ruby
class Book < ApplicationRecord
  def available?
    stock.positive?
  end
end
```

`class` define a classe, `<` indica herança, `def` define um método. O último valor avaliado é retornado sem precisar de `return`. O sufixo `?` é uma convenção para métodos que respondem verdadeiro/falso. `!` em métodos Rails, como `save!`, costuma indicar que falhas geram exceções; o significado depende do método, não é uma regra imposta pela linguagem.

```ruby
title = 'Dom Casmurro'              # String
stock = 12                          # Integer
attributes = { title: title, stock: stock } # Hash com chaves Symbol
categories = ['Ficção', 'Poesia']    # Array
message = "Temos #{stock} exemplares" # interpolação em aspas duplas
```

`:title` é um Symbol: um identificador imutável comum em chaves e opções. `title:` dentro de um Hash é a forma abreviada de `:title =>`. `nil` representa ausência. Somente `nil` e `false` são falsos em condicionais Ruby: `0` e `''` são verdadeiros.

## 2. Acompanhe um cadastro

1. O formulário monta um `BookInput` em TypeScript.
2. `booksApi.save` faz POST `/api/v1/books`, com `{ "book": { ... } }`.
3. `config/routes.rb` direciona para `Api::V1::BooksController#create`.
4. `book_params` exige o envelope e permite os campos conhecidos.
5. `Book.new` instancia o model. `save` normaliza, valida e grava.
6. Rails responde JSON com status 201, ou lista de erros com status 422.
7. O frontend atualiza a lista somente quando a gravação é confirmada.

Em `@book`, `@` indica uma variável de instância, compartilhada entre métodos da mesma instância do controller. Variáveis sem `@` são locais. `module Api` e `module V1` criam namespaces e evitam colisões de nomes.

## 3. Abra o console

```sh
docker compose exec api bundle exec rails console
```

```ruby
Book.count
Book.alphabetical.pluck(:title)
book = Book.first
book.stock
book.update(stock: 15)
book.reload.stock
book.update(stock: -1) # false; não grava
book.errors.full_messages
```

ActiveRecord fornece consultas e persistência. `update` retorna um boolean; `update!` lança uma exceção em caso de validação inválida. `reload` recarrega o estado do banco. `pluck` seleciona colunas sem instanciar todos os models.

## 4. Leia os blocos

```ruby
books.each do |book|
  puts book.title
end

titles = books.map { |book| book.title }
```

Um bloco é código passado a um método. `|book|` declara o argumento do bloco. `each` itera, enquanto `map` retorna um novo Array com os resultados. Em `seeds.rb`, seis valores são desestruturados nos parâmetros do bloco. `find_or_create_by!` encontra um ISBN existente ou cria um registro; execute o seed novamente e confira que `Book.count` não aumenta.

## 5. O model protege o banco

Leia `app/models/book.rb`. `validates` é uma chamada de método herdado de Rails. `presence: true` é uma opção, e `numericality: { ... }` é um Hash dentro de outro Hash.

```ruby
scope :alphabetical, -> { order(:title, :id) }
```

`-> { ... }` é uma lambda. Rails avalia esse bloco quando a consulta é usada. `before_validation` chama `normalize_text` antes das validações. `title&.strip` usa navegação segura: se o título for nil, retorna nil sem chamar strip.

Dinheiro é inteiro em centavos. O frontend apresenta R$ 39,90, mas a API recebe `price_cents: 3990`. A validação do valor bruto (`_before_type_cast`) impede que um decimal seja truncado silenciosamente pelo campo inteiro. A migration adiciona índice único para ISBN e constraints para estoque e preço não negativos, complementando a validação Ruby.

## 6. HTTP é responsabilidade do controller

Leia `books_controller.rb`. `before_action :set_book` carrega o livro para show, update e destroy. `private` marca métodos auxiliares. O controller base converte exceções esperadas em respostas JSON: 404 para registro ausente, 400 para parâmetro obrigatório ausente e 422 para ISBN duplicado no banco.

`%i[show update destroy]` é um Array de Symbols. `render json: book` serializa o model. `head :no_content` retorna 204 sem corpo, e o cliente TS trata esse caso antes de tentar ler JSON.

## 7. Faça uma pequena mudança

Adicione um campo `publisher` (editora):

```sh
docker compose exec api bundle exec rails generate migration AddPublisherToBooks publisher:string
docker compose exec api bundle exec rails db:migrate
```

Depois, permita `:publisher` no controller, adicione o atributo ao type TS e ao formulário e escreva um teste que cadastra e consulta a editora. Isso demonstra uma alteração atravessando banco, backend, contrato e interface. Para alterar código com o compose fornecido, reconstrua a imagem após editar (`docker compose up --build`). Migrations geradas dentro do container precisam ser copiadas para a pasta local para serem versionadas; executá-las no WSL diretamente no checkout é uma alternativa.

## 8. Convenções de mercado presentes aqui

Rotas REST versionadas; strong parameters; regras no model; migrations rastreáveis; banco persistente; JSON e códigos HTTP consistentes; configuração por ambiente; CORS por origem explícita; testes de integração. Não adicionamos abstrações sem necessidade. O próximo passo é autenticação, paginação e uma pipeline de CI — depois que o fluxo simples estiver entendido.

Referências: https://www.ruby-lang.org/pt/documentation/ e https://guides.rubyonrails.org/api_app.html.
