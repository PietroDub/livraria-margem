module FactoryHelpers
  def create(factory_name, attributes = {})
    factory_class(factory_name).create!(factory_attributes(factory_name).merge(attributes))
  end

  def create_list(factory_name, amount, attributes = {})
    Array.new(amount) { |index| create(factory_name, attributes_for_list(factory_name, attributes, index)) }
  end

  private

  def factory_class(factory_name)
    { user: User, book: Book }.fetch(factory_name) do
      raise ArgumentError, "Factory desconhecida: #{factory_name}"
    end
  end

  def factory_attributes(factory_name)
    case factory_name
    when :user
      { name: 'Pessoa de Teste', email: "pessoa-#{SecureRandom.hex(4)}@example.com", password: 'senha-segura-123' }
    when :book
      {
        title: 'Livro de Teste', author: 'Autora de Teste', category: 'Tecnologia',
        isbn: SecureRandom.random_number(10**13).to_s.rjust(13, '0'),
        price_cents: 4990, stock: 5, description: 'Livro criado para testes.', user: create(:user)
      }
    end
  end

  def attributes_for_list(factory_name, attributes, index)
    return attributes.merge(email: "pessoa-#{SecureRandom.hex(4)}-#{index}@example.com") if factory_name == :user
    return attributes.merge(isbn: (978_000_000_0000 + index).to_s) if factory_name == :book

    attributes
  end
end
