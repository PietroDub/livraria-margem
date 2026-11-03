# Pediu o CRUD em passos, a partir de um exemplo mínimo

Pietro quer entender métodos de model, scope e CRUD fazendo um caso simples, um passo de cada vez. O piso continua o mesmo: já usa `find`, `new`/`save`, `update`, `destroy!` e os scopes no `BooksController`, sem um mapa de quem define cada um e do que cada um devolve.

## Implications

Uma lição por verbo depois do mapa relação-contra-registro. Não abrir Create, Update e Delete na mesma sessão. O próximo passo combinado é Create (`new` + `save`), que é o que `BooksController#create` já faz.
