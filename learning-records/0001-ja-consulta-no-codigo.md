# Já consulta Book e User no código

Pietro usa `Book.find`, `User.find_by`, scopes com `where` e `order`, e já viu em `docs/APRENDENDO_RUBY.md` que `pluck` pega colunas sem instanciar models. Não há evidência ainda de que ele escolha entre `pluck`, `pick` e `ids`, nem de que preveja que `pluck` devolve `Array` e encerra a cadeia.

## Evidence

Uso no repositório (`books_controller.rb`, `users_controller.rb`, `book.rb`) e a menção de uma linha a `pluck` nas notas locais. Profundidade alegada: uso no projeto, não explicação da interface.

## Implications

A primeira lição não apresenta Active Record do zero. O piso é “já chamo esses métodos”. O teto imediato é extrair valores. `find` contra `find_by` contra relação fica para a sessão seguinte, depois de um retrieval sem consulta à lição.
