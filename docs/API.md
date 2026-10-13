# Contrato HTTP

Base local: `http://localhost:3001/api/v1`. Tipo de conteúdo: `application/json`.

| Método | Caminho | Resposta |
|---|---|---|
| GET | /books | 200, Array de livros |
| GET | /books/:id | 200, livro; 404 se ausente |
| POST | /books | 201, livro criado |
| PATCH | /books/:id | 200, livro atualizado |
| DELETE | /books/:id | 204, sem corpo |

Exemplo de POST:

```json
{
  "book": {
    "title": "Ruby na prática",
    "author": "Ana Silva",
    "category": "Tecnologia",
    "isbn": "1234567890",
    "price_cents": 4900,
    "stock": 3,
    "description": "Exemplo didático"
  }
}
```

Livro retornado: mesmos campos, mais `id`, `created_at` e `updated_at`. PATCH aceita apenas os campos que deseja alterar, dentro de `book`. `id` e timestamps não podem ser atribuídos pelo cliente.

Regras: título obrigatório até 180 caracteres; autor até 120; categoria pertencente à lista do model; ISBN único com 10 ou 13 dígitos; preço inteiro entre 0 e 100000000 centavos; estoque inteiro entre 0 e 1000000; descrição até 2000 caracteres. A validação de ISBN é de formato, não de dígito verificador.

Erro de validação: status 422, `{"errors":["Stock must be greater than or equal to 0"]}`. Mensagens padrão do Rails estão em inglês; os erros HTTP gerais estão em português. Livro ausente: 404, `{"error":"Livro não encontrado."}`. Envelope ausente: 400. JSON malformado é rejeitado pelo parser Rails.

Teste pelo PowerShell:

```powershell
$book = @{ book = @{ title='Ruby na prática'; author='Ana'; category='Tecnologia'; isbn='1234567890'; price_cents=4900; stock=3; description='' } } | ConvertTo-Json
$created = Invoke-RestMethod -Method Post -Uri http://localhost:3001/api/v1/books -ContentType application/json -Body ([System.Text.Encoding]::UTF8.GetBytes($book))
Invoke-RestMethod http://localhost:3001/api/v1/books
Invoke-RestMethod -Method Patch -Uri "http://localhost:3001/api/v1/books/$($created.id)" -ContentType application/json -Body '{"book":{"stock":7}}'
Invoke-RestMethod -Method Delete -Uri "http://localhost:3001/api/v1/books/$($created.id)"
```

Para testar um erro, envie estoque -1. A API deve responder 422 e preservar os dados anteriores.
