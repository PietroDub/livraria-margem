## muda a resposta de array! para books ou seja objeto de books

json.books @books do |book|
  json.partial! 'book', book: book
end

json.pagination do
  json.current_page @books.current_page
  json.total_pages @books.total_pages
  json.total_count @books.total_count
end