require 'test_helper'
class BooksTest < ActionDispatch::IntegrationTest
  def attributes
    { title: 'Ruby na prática', author: 'Ana', category: 'Tecnologia', isbn: '1234567890', price_cents: 4900, stock: 2 }
  end
  test 'complete CRUD lifecycle persists changes' do
    post '/api/v1/books', params: { book: attributes }, as: :json
    assert_response :created
    id = response.parsed_body.fetch('id')
    get '/api/v1/books'
    assert_response :success
    assert response.parsed_body.any? { |book| book['id'] == id }
    get "/api/v1/books/#{id}"
    assert_equal 'Ruby na prática', response.parsed_body['title']
    patch "/api/v1/books/#{id}", params: { book: { stock: 7 } }, as: :json
    assert_response :success
    assert_equal 7, Book.find(id).stock
    delete "/api/v1/books/#{id}"
    assert_response :no_content
    get "/api/v1/books/#{id}"
    assert_response :not_found
  end
  test 'invalid input returns 422 without creating a record' do
    assert_no_difference('Book.count') do
      post '/api/v1/books', params: { book: attributes.merge(stock: -1) }, as: :json
      assert_response :unprocessable_entity
      assert response.parsed_body['errors'].any?
    end
  end
  test 'missing book envelope returns 400' do
    post '/api/v1/books', params: { title: 'Example' }, as: :json
    assert_response :bad_request
  end
  test 'client cannot assign protected id' do
    post '/api/v1/books', params: { book: attributes.merge(id: 999_999) }, as: :json
    assert_response :created
    assert_not_equal 999_999, response.parsed_body['id']
  end
end
