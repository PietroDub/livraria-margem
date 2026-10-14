# Livraria Margem — API (estudo)

Este repositório é **básico de propósito**. Existe para o Pietro aprender Ruby e Ruby on Rails, não para parecer produção.

## Quem está aprendendo

- Experiência forte em **C# / Visual Studio**, **Node.js**, **JS/TS**, **React** e **Next.js**.
- Use esses backgrounds **só quando a analogia esclarece** um conceito de Ruby/Rails (ex.: model ≈ entidade + validações, `scope` ≈ query reutilizável, callback ≈ hook).
- Não assuma idioms de C# ou TypeScript no código. Prefira o jeito idiomático de Rails.

## Como ensinar e escrever código

- Explique **sintaxe e regras da linguagem** (símbolos, blocos, `self`, callbacks, Active Record) sem ser prolixo.
- Comentários no código: só o que o código **não** deixa óbvio. Sem repetir `validates :title, presence: true`.
- Evite overengineering: sem gems extras, services, jobs ou padrões “enterprise” a menos que o Pietro peça.
- Preferir o caminho Rails: model, controller, migration, rotas — o ciclo MVC clássico.
- Quando algo for específico do Rails (e não de Ruby puro), deixe isso explícito.

## Stack deste `api/`

- Ruby on Rails, JSON API, Active Record.
- Convenções do framework valem mais que inventar estrutura à la Node/Nest/Next.

## Tom das respostas

- Direto, em português, no nível de quem já programa e está migrando de stack.
- Se uma linha for idiomática (`validate :metodo`, `scope :nome, -> { ... }`), explique o que o Rails faz com ela, não só a tradução palavra a palavra.
