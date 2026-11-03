# Mission: Active Record na Margem

## Why
A API da livraria já grava e busca livros e usuários por Active Record. O objetivo é escrever essas consultas de propósito: saber o que cada método devolve, quando a SQL dispara, e qual chamada cabe em `BooksController` e `UsersController`.

## Success looks like
- Diante de uma necessidade da API, escolher `find`, `find_by`, uma relação (`where`, `order`, scope) ou um extrator de valores (`pluck`, `pick`, `ids`).
- Prever o tipo de retorno e se a consulta já rodou, antes de abrir o console.
- Ler `Book.alphabetical.search(params[:q])` e `User.find_by(email:)` e explicar a diferença em uma frase.

## Constraints
- Aulas em português, curtas, com exemplos de `Book` e `User` deste repositório.
- Fonte de verdade: os [guias oficiais do Rails](https://guides.rubyonrails.org/active_record_querying.html) e a API do Active Record. O console do projeto sobe com `docker compose exec api bundle exec rails console`.
- Uma habilidade por lição.

## Out of scope
- Validações, callbacks e migrations, até a interface de consulta estar firme.
- SQL cru (`find_by_sql`, `select_all`) como hábito. Ficam na ficha de referência como saída quando a interface não alcança.
