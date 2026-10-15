# O objeto `json` é fornecido pelo Jbuilder.
# Cada símbolo abaixo vira uma chave no JSON enviado ao cliente.
json.extract! @book, :id, :title, :author, :category, :isbn,
              :price_cents, :stock, :description, :user_id,
              :created_at, :updated_at
