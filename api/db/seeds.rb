# find_or_create_by! torna o seed repetível sem duplicar os registros.
[
  ['Dom Casmurro', 'Machado de Assis', 'Literatura brasileira', '9788535914849', 3990, 12],
  ['O pequeno príncipe', 'Antoine de Saint-Exupéry', 'Ficção', '9788522031447', 2990, 8],
  ['Código limpo', 'Robert C. Martin', 'Tecnologia', '9788576082675', 8990, 3],
  ['A hora da estrela', 'Clarice Lispector', 'Literatura brasileira', '9788532529626', 4490, 6],
  ['1984', 'George Orwell', 'Ficção', '9788535914848', 3490, 0],
  ['Alguma poesia', 'Carlos Drummond de Andrade', 'Poesia', '9788535921076', 4290, 5]
].each do |title, author, category, isbn, price_cents, stock|
  Book.find_or_create_by!(isbn: isbn) do |book|
    book.assign_attributes(title: title, author: author, category: category,
                           price_cents: price_cents, stock: stock, description: '')
  end
end
