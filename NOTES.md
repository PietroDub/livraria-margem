# Notas de ensino

- Pietro pediu as aulas em português, ancoradas no guia de querying, seção Finding Records and Values.
- Exemplos saem de `api/app/models/book.rb`, `user.rb`, `application_record.rb` e dos controllers em `api/app/controllers`.
- Console deste repo: `docker compose exec api bundle exec rails console` (ver `docs/APRENDENDO_RUBY.md`).
- Ele já leu uma linha sobre `pluck` nessas notas e já chama `find`, `find_by`, `where` e scopes no código. Não reapresentar `pluck` do zero; cobrar a escolha entre `pluck`, `pick` e `ids`.
- Perguntou se `Book.search` deveria ser `def` porque tem `if`. Resposta dada na lição 0002: o guia permite condicional em scope; a troca é estilo; o ramo vazio precisa continuar `all` por causa de `alphabetical.search.page`. Ainda não houve quiz confirmado.
- Próxima sessão: retrieval da lição 0001 sem a página aberta, e o quiz da 0002. Se os dois acertarem, seguir para `find` / `find_by` contra relação.
