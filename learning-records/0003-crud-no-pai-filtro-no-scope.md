# CRUD no pai, filtro no scope

Pietro descreveu o model assim: métodos CRUD vêm da classe pai, e filtros como pesquisa vão em scope. A metade do CRUD confere com o guia de Basics. A metade do filtro mistura duas coisas: `where` e `order` também são herdados; `alphabetical` só nomeia um `order`. Ele ainda não explica por que `Book.alphabetical.where` encadeia e `Book.find(1).where` não.

## Evidence

Mensagem em que ele pede para retomar as duas linhas. Disse que a sintaxe e a diferença entre elas continuam confusas.

## Implications

Não reexplicar “CRUD é herdado”. A lição 0004 é o receptor do ponto. Create espera essa cadeia ficar estável.
