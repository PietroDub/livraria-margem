# Livraria Margem

Um CRUD pequeno e completo para aprender Ruby através de uma aplicação real. O frontend é Next.js **16.4.0**, React 19.3 e TypeScript, usando App Router. A API é Ruby on Rails **8.1.4**, com SQLite. Essas versões estáveis foram verificadas em 13/10/2026; o lockfile registra as dependências do frontend.

Os scripts usam o bundler Webpack suportado pelo Next.js: o Turbopack apresentou erro de canonicalização de caminhos neste ambiente Windows restrito. O framework continua sendo Next.js real; o código da interface permanece em TypeScript.

## Comece aqui

O caminho mais simples no Windows é instalar Docker Desktop com WSL 2, iniciar o Docker e executar nesta pasta:

```sh
docker compose up --build
```

Abra http://localhost:3000. A API roda em http://localhost:3001/api/v1/books e o healthcheck em http://localhost:3001/up. O seed cria seis livros de exemplo. Os ISBNs são identificadores didáticos, sem garantia de corresponder à edição comercial mencionada. O banco permanece no volume `books_data` após reiniciar os containers. `docker compose down` encerra os serviços; adicionar `-v` APAGA o banco.

O compose é para desenvolvimento: instala dependências, prepara o banco e inicia os servidores. Não é uma configuração de produção. A imagem Ruby resolve as gems no primeiro build; use `bundle lock` e versione o Gemfile.lock antes de distribuir uma release reproduzível da API.

## Rodar sem Docker

Requisitos: Node.js 24, npm, Ruby 3.2+ (recomendado 3.4), Bundler e bibliotecas de compilação/SQLite. No Windows, prefira RubyInstaller com Devkit ou WSL para o backend.

Terminal 1:

```sh
cd api
bundle install
bundle exec rails db:prepare
bundle exec rails db:seed
bundle exec rails server -p 3001
```

Terminal 2, na raiz do projeto:

```sh
npm ci
```

Copie `.env.example` para `.env.local` (`Copy-Item .env.example .env.local` no PowerShell). Depois:

```sh
npm run dev
```

## Modos de dados

- **API**, padrão: o frontend envia HTTP para Rails. Falhas de conexão são exibidas; não há fallback silencioso.
- **Demo**: defina `NEXT_PUBLIC_DATA_MODE=demo`. O CRUD usa localStorage apenas no navegador e não envia requisições para Rails. Esse é o modo do build preparado para Sites, que não executa Ruby. A publicação não foi concluída por bloqueio de aprovação do ambiente.

As variáveis NEXT_PUBLIC são incorporadas ao frontend. Mudanças exigem reiniciar o dev server ou reconstruir o export. Para conectar uma API remota, configure `NEXT_PUBLIC_API_URL=https://seu-backend/api/v1`, modo `api`, e permita a origem do frontend em `FRONTEND_ORIGINS` na API. Nunca coloque segredos em NEXT_PUBLIC.

## Estrutura

```text
src/app/page.tsx                  catálogo e guia interativo
src/app/globals.css               estilos responsivos
src/lib/books.ts                  contrato TS e cliente HTTP
api/config/routes.rb             URLs e verbos REST
api/app/controllers/api/v1/       entrada HTTP, parâmetros e respostas
api/app/models/                  validações e persistência
api/db/migrate/                  evolução do banco
api/db/seeds.rb                  dados iniciais
api/test/                        testes de model e integração
docs/APRENDENDO_RUBY.md          roteiro comentado
docs/API.md                     contrato e exemplos HTTP
```

Busca e filtros são locais após GET da lista: uma escolha simples para o pequeno catálogo. Models guardam regras, controllers cuidam de HTTP, migrations cuidam do schema. Não há camada de services porque esse CRUD não tem lógica que a justifique. Tampouco há autenticação, pagamentos ou pedidos: o escopo é um catálogo local para aprendizado. Antes de disponibilizar a API na internet, implemente autenticação/autorização, HTTPS, backups, limites de requisição e paginação. CORS não é autenticação.

## Verificação

```sh
npm run typecheck
npm run build
```

Para gerar o frontend demonstrativo (PowerShell):

```powershell
$env:NEXT_PUBLIC_DATA_MODE = 'demo'
npm run build
```

O projeto usa export estático e gera `out/`. Para visualizar o resultado, sirva essa pasta com um servidor HTTP. `next start` não serve um export estático; para desenvolvimento use `npm run dev`.

Testes Rails com Docker em execução:

```sh
docker compose exec api bundle exec rails db:prepare RAILS_ENV=test
docker compose exec api bundle exec rails test
```

Ou no terminal da pasta `api`, sem Docker:

```sh
bundle exec rails db:prepare RAILS_ENV=test
bundle exec rails test
```

Os testes exercitam o ciclo completo do CRUD, persistência, ISBN duplicado, atributos protegidos, requisições inválidas e campos numéricos. Consulte `docs/VERIFICACAO.md` para o que foi efetivamente executado na entrega.

## Leia para aprender

Comece por `docs/APRENDENDO_RUBY.md`, experimente `rails console` e acompanhe cada ação do catálogo na aba Network do navegador. A seção **Aprender Ruby** no site apresenta os mesmos conceitos em etapas.
