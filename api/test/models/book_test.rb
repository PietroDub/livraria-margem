require 'test_helper'
class BookTest < ActiveSupport::TestCase
  def attributes
    { title: 'Ruby na prática', author: 'Ana', category: 'Tecnologia', isbn: '1234567890', price_cents: 4900, stock: 2 }
  end
  test 'rejects missing title, negative stock and fractional cents' do
    book = Book.new(attributes.merge(title: ' ', stock: -1, price_cents: 1.5))
    assert_not book.valid?
    assert book.errors[:title].any?
    assert book.errors[:stock].any?
    assert book.errors[:price_cents].any?
  end
  test 'normalizes text and rejects duplicate ISBN' do
    book = Book.create!(attributes.merge(title: '  Ruby na prática  '))
    assert_equal 'Ruby na prática', book.title
    assert_not Book.new(attributes).valid?
  end
end
