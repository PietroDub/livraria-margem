json.array! @books do |book|
  json.extract! book, :id, :title, :author, :category, :isbn,
                :price_cents, :stock, :description, :user_id,
                :created_at, :updated_at
end